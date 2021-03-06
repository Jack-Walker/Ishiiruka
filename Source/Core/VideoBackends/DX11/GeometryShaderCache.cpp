// Copyright 2013 Dolphin Emulator Project
// Licensed under GPLv2+
// Refer to the license.txt file included.

#include <string>

#include "Common/FileUtil.h"
#include "Common/LinearDiskCache.h"
#include "Common/StringUtil.h"

#include "Core/ConfigManager.h"

#include "VideoBackends/DX11/D3DBase.h"
#include "VideoBackends/DX11/D3DPtr.h"
#include "VideoBackends/DX11/D3DShader.h"
#include "VideoBackends/DX11/D3DUtil.h"
#include "VideoBackends/DX11/FramebufferManager.h"
#include "VideoBackends/DX11/GeometryShaderCache.h"
#include "VideoBackends/DX11/Globals.h"

#include "VideoCommon/Debugger.h"
#include "VideoCommon/GeometryShaderGen.h"
#include "VideoCommon/GeometryShaderManager.h"
#include "VideoCommon/HLSLCompiler.h"
#include "VideoCommon/Statistics.h"
#include "VideoCommon/VideoConfig.h"

namespace DX11
{

GeometryShaderCache::GSCache GeometryShaderCache::s_geometry_shaders;
const GeometryShaderCache::GSCacheEntry* GeometryShaderCache::s_last_entry;
GeometryShaderUid GeometryShaderCache::s_last_uid;
GeometryShaderUid GeometryShaderCache::s_external_last_uid;
UidChecker<GeometryShaderUid, ShaderCode> GeometryShaderCache::geometry_uid_checker;
const GeometryShaderCache::GSCacheEntry GeometryShaderCache::s_pass_entry;
static HLSLAsyncCompiler *s_compiler;
static Common::SpinLock<true> s_geometry_shaders_lock;

D3D::GeometryShaderPtr ClearGeometryShader;
D3D::GeometryShaderPtr CopyGeometryShader;

LinearDiskCache<GeometryShaderUid, u8> g_gs_disk_cache;

ID3D11GeometryShader* GeometryShaderCache::GetClearGeometryShader() { return (g_ActiveConfig.iStereoMode > 0) ? ClearGeometryShader.get() : nullptr; }
ID3D11GeometryShader* GeometryShaderCache::GetCopyGeometryShader() 
{ 
	return (g_ActiveConfig.iStereoMode > 0) ? CopyGeometryShader.get() : nullptr;
}

D3D::ConstantStreamBuffer* gscbuf = nullptr;
static UINT s_gscbuf_offset = 0;
static UINT s_gscbuf_size = 0;

std::tuple<ID3D11Buffer*, UINT, UINT>  GeometryShaderCache::GetConstantBuffer()
{
	if (GeometryShaderManager::IsDirty())
	{
		s_gscbuf_size = sizeof(GeometryShaderConstants);
		s_gscbuf_offset = gscbuf->AppendData((void*)&GeometryShaderManager::constants, s_gscbuf_size);
		GeometryShaderManager::Clear();
		ADDSTAT(stats.thisFrame.bytesUniformStreamed, s_gscbuf_size);
		s_gscbuf_size = (UINT)(((s_gscbuf_size + 255) & (~255)) / 16);
	}
	return std::tuple<ID3D11Buffer*, UINT, UINT>(gscbuf->GetBuffer(), s_gscbuf_offset, s_gscbuf_size);
}

// this class will load the precompiled shaders into our cache
class GeometryShaderCacheInserter : public LinearDiskCacheReader<GeometryShaderUid, u8>
{
public:
	void Read(const GeometryShaderUid &key, const u8* value, u32 value_size)
	{
		GeometryShaderCache::InsertByteCode(key, value, value_size);
	}
};

const char* gs_clear_shader_code = R"hlsl(
struct VSOUTPUT
{
	float4 vPosition : SV_Position;
	float4 vColor0   : COLOR0;
};
struct GSOUTPUT
{
	float4 vPosition   : SV_Position;
	float4 vColor0   : COLOR0;
	uint slice    : SV_RenderTargetArrayIndex;
};
[maxvertexcount(6)]
void main(triangle VSOUTPUT o[3], inout TriangleStream<GSOUTPUT> Output)
{
	for(int slice = 0; slice < 2; slice++)
	{
		for(int i = 0; i < 3; i++)
		{
			GSOUTPUT OUT;
			OUT.vPosition = o[i].vPosition;
			OUT.vColor0 = o[i].vColor0;
			OUT.slice = slice;
			Output.Append(OUT);
		}
		Output.RestartStrip();
	}
}
)hlsl";

const char* gs_copy_shader_code = R"hlsl(
struct VSOUTPUT
{
	float4 vPosition : SV_Position;
	float3 vTexCoord : TEXCOORD0;
	float  vTexCoord1 : TEXCOORD1;
	float4  vTexCoord2 : TEXCOORD2;
	float4  vTexCoord3 : TEXCOORD2;
};
struct GSOUTPUT
{
	float4 vPosition : SV_Position;
	float3 vTexCoord : TEXCOORD0;
	float  vTexCoord1 : TEXCOORD1;
	float4  vTexCoord2 : TEXCOORD2;
	float4  vTexCoord3 : TEXCOORD3;
	uint slice    : SV_RenderTargetArrayIndex;
};
[maxvertexcount(6)]
void main(triangle VSOUTPUT o[3], inout TriangleStream<GSOUTPUT> Output)
{
	for(int slice = 0; slice < 2; slice++)
	{
		for(int i = 0; i < 3; i++)
		{
			GSOUTPUT OUT;
			OUT.vPosition = o[i].vPosition;
			OUT.vTexCoord = o[i].vTexCoord;
			OUT.vTexCoord1 = o[i].vTexCoord1;
			OUT.vTexCoord2 = o[i].vTexCoord2;
			OUT.vTexCoord3 = o[i].vTexCoord3;
			OUT.vTexCoord.z = slice;
			OUT.slice = slice;
			Output.Append(OUT);
		}
		Output.RestartStrip();
	}
}
)hlsl";

void GeometryShaderCache::Init()
{
	s_compiler = &HLSLAsyncCompiler::getInstance();
	s_geometry_shaders_lock.unlock();
	bool use_partial_buffer_update = D3D::SupportPartialContantBufferUpdate();
	u32 gbsize = use_partial_buffer_update ? 4 * 1024 * 1024 : ROUND_UP(sizeof(GeometryShaderConstants), 16); // must be a multiple of 16
	gscbuf = new D3D::ConstantStreamBuffer(gbsize);
	ID3D11Buffer* buf = gscbuf->GetBuffer();
	CHECK(buf != nullptr, "Create geometry shader constant buffer (size=%u)", gbsize);
	D3D::SetDebugObjectName(buf, "geometry shader constant buffer used to emulate the GX pipeline");

	// used when drawing clear quads
	ClearGeometryShader = D3D::CompileAndCreateGeometryShader(gs_clear_shader_code);
	CHECK(ClearGeometryShader != nullptr, "Create clear geometry shader");
	D3D::SetDebugObjectName(ClearGeometryShader.get(), "clear geometry shader");

	// used for buffer copy
	CopyGeometryShader = D3D::CompileAndCreateGeometryShader(gs_copy_shader_code);
	CHECK(CopyGeometryShader != nullptr, "Create copy geometry shader");
	D3D::SetDebugObjectName(CopyGeometryShader.get(), "copy geometry shader");
	
	Clear();

	if (!File::Exists(File::GetUserPath(D_SHADERCACHE_IDX)))
		File::CreateDir(File::GetUserPath(D_SHADERCACHE_IDX));

	std::string cache_filename = StringFromFormat("%sIDX11-%s-gs.cache", File::GetUserPath(D_SHADERCACHE_IDX).c_str(),
		SConfig::GetInstance().m_strUniqueID.c_str());
	GeometryShaderCacheInserter inserter;
	g_gs_disk_cache.OpenAndRead(cache_filename, inserter);

	if (g_Config.bEnableShaderDebugging)
		Clear();

	s_last_entry = nullptr;
}

// ONLY to be used during shutdown.
void GeometryShaderCache::Clear()
{
	for (auto& iter : s_geometry_shaders)
		iter.second.Destroy();
	s_geometry_shaders.clear();
	s_geometry_shaders_lock.unlock();
	geometry_uid_checker.Invalidate();
	
	s_last_entry = nullptr;
}

void GeometryShaderCache::Shutdown()
{
	if (s_compiler)
	{
		s_compiler->WaitForFinish();
	}
	if (gscbuf != nullptr)
	{
		delete gscbuf;
		gscbuf = nullptr;
	}

	ClearGeometryShader.reset();
	CopyGeometryShader.reset();

	Clear();
	g_gs_disk_cache.Sync();
	g_gs_disk_cache.Close();
}

void GeometryShaderCache::PrepareShader(
	u32 primitive_type,
	const XFMemory &xfr,
	const u32 components,
	bool ongputhread)
{
	GeometryShaderUid uid;
	GetGeometryShaderUid(uid, primitive_type, API_D3D11, xfr, components);
	if (ongputhread)
	{
		s_compiler->ProcCompilationResults();
#if defined(_DEBUG) || defined(DEBUGFAST)
		if (g_ActiveConfig.bEnableShaderDebugging)
		{
			ShaderCode code;
			GenerateGeometryShaderCode(code, primitive_type, API_D3D11, xfr, components);
			geometry_uid_checker.AddToIndexAndCheck(code, uid, "Geometry", "g");
		}
#endif
		// Check if the shader is already set
		if (s_last_entry)
		{
			if (uid == s_last_uid)
			{
				return;
			}
		}
		s_last_uid = uid;
		// Check if the shader is a pass-through shader
		if (uid.GetUidData().IsPassthrough())
		{
			// Return the default pass-through shader
			s_last_entry = &s_pass_entry;
			return;
		}
		GFX_DEBUGGER_PAUSE_AT(NEXT_PIXEL_SHADER_CHANGE, true);
	}
	else
	{
		if (s_external_last_uid == uid)
		{
			return;
		}
		s_external_last_uid = uid;
	}
	

	s_geometry_shaders_lock.lock();
	GSCacheEntry* entry = &s_geometry_shaders[uid];
	s_geometry_shaders_lock.unlock();
	if (ongputhread)
	{
		s_last_entry = entry;
	}
	// Compile only when we have a new instance
	if (entry->initialized.test_and_set())
	{
		return;
	}

	// Need to compile a new shader
	ShaderCode code;
	ShaderCompilerWorkUnit *wunit = s_compiler->NewUnit(GEOMETRYSHADERGEN_BUFFERSIZE);
	code.SetBuffer(wunit->code.data());
	GenerateGeometryShaderCode(code, primitive_type, API_D3D11, xfr, components);
	wunit->codesize = (u32)code.BufferSize();
	wunit->entrypoint = "main";
	wunit->flags = D3DCOMPILE_SKIP_VALIDATION | D3DCOMPILE_OPTIMIZATION_LEVEL3;
	wunit->target = D3D::GeometryShaderVersionString();

	wunit->ResultHandler = [uid, entry](ShaderCompilerWorkUnit* wunit)
	{
		if (SUCCEEDED(wunit->cresult))
		{
			ID3DBlob* shaderBuffer = wunit->shaderbytecode;
			const u8* bytecode = (const u8*)shaderBuffer->GetBufferPointer();
			u32 bytecodelen = (u32)shaderBuffer->GetBufferSize();
			g_gs_disk_cache.Append(uid, bytecode, bytecodelen);
			PushByteCode(bytecode, bytecodelen, entry);
#if defined(_DEBUG) || defined(DEBUGFAST)
			if (g_ActiveConfig.bEnableShaderDebugging)
			{
				entry->code = wunit->code.data();
			}
#endif
		}
		else
		{
			static int num_failures = 0;
			char szTemp[MAX_PATH];
			sprintf(szTemp, "%sbad_gs_%04i.txt", File::GetUserPath(D_DUMP_IDX).c_str(), num_failures++);
			std::ofstream file;
			OpenFStream(file, szTemp, std::ios_base::out);
			file << ((const char *)wunit->code.data());
			file << ((const char *)wunit->error->GetBufferPointer());
			file.close();

			PanicAlert("Failed to compile geometry shader!\nThis usually happens when trying to use Dolphin with an outdated GPU or integrated GPU like the Intel GMA series.\n\nIf you're sure this is Dolphin's error anyway, post the contents of %s along with this error message at the forums.\n\nDebug info (%s):\n%s",
				szTemp,
				D3D::GeometryShaderVersionString(),
				(char*)wunit->error->GetBufferPointer());
		}
	};
	s_compiler->CompileShaderAsync(wunit);
}

bool GeometryShaderCache::TestShader()
{
	int count = 0;
	while (!s_last_entry->compiled)
	{
		s_compiler->ProcCompilationResults();
		if (g_ActiveConfig.bFullAsyncShaderCompilation)
		{
			break;
		}
		Common::cYield(count++);
	}
	return s_last_entry->shader != nullptr && s_last_entry->compiled;
}

void GeometryShaderCache::PushByteCode(const void* bytecode, unsigned int bytecodelen, GeometryShaderCache::GSCacheEntry* entry)
{
	entry->shader = std::move(D3D::CreateGeometryShaderFromByteCode(bytecode, bytecodelen));
	entry->compiled = true;
	if (entry->shader != nullptr)
	{
		// TODO: Somehow make the debug name a bit more specific
		D3D::SetDebugObjectName(entry->shader.get(), "a Geometry shader of GeometryShaderCache");
		INCSTAT(stats.numGeometryShadersCreated);
		SETSTAT(stats.numGeometryShadersAlive, s_geometry_shaders.size());
	}
}

void GeometryShaderCache::InsertByteCode(const GeometryShaderUid &uid, const void* bytecode, u32 bytecodelen)
{
	GSCacheEntry* entry = &s_geometry_shaders[uid];
	entry->initialized.test_and_set();
	PushByteCode(bytecode, bytecodelen, entry);
}

}  // DX11
