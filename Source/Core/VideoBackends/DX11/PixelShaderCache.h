// Copyright 2013 Dolphin Emulator Project
// Licensed under GPLv2+
// Refer to the license.txt file included.

#pragma once
#include <atomic>
#include <unordered_map>
#include <d3d11_2.h>
#include "VideoBackends/DX11/D3DPtr.h"
#include "VideoCommon/PixelShaderGen.h"

enum DSTALPHA_MODE;

namespace DX11
{

class PixelShaderCache
{
public:
	static void Init();
	static void Clear();
	static void Shutdown();
	static void PrepareShader(
		DSTALPHA_MODE dstAlphaMode,
		u32 componets,
		const XFMemory &xfr,
		const BPMemory &bpm, bool ongputhread);
	static bool TestShader();
	static void InsertByteCode(const PixelShaderUid &uid, const void* bytecode, u32 bytecodelen);

	static ID3D11PixelShader* GetActiveShader() { return s_last_entry->shader.get(); }
	static std::tuple<ID3D11Buffer*, UINT, UINT> GetConstantBuffer();

	static ID3D11PixelShader* GetColorMatrixProgram(bool multisampled);
	static ID3D11PixelShader* GetColorCopyProgram(bool multisampled, bool ssaa = false);
	static ID3D11PixelShader* GetDepthMatrixProgram(bool multisampled);
	static ID3D11PixelShader* GetClearProgram();
	static ID3D11PixelShader* ReinterpRGBA6ToRGB8(bool multisampled);
	static ID3D11PixelShader* ReinterpRGB8ToRGBA6(bool multisampled);

	static void InvalidateMSAAShaders();

private:
	struct PSCacheEntry
	{
		D3D::PixelShaderPtr shader;
		bool compiled;
		std::atomic_flag initialized;
		std::string code;

		PSCacheEntry() : compiled(false)
		{
			initialized.clear();
		}
		void Destroy() { shader.reset(); }
	};
	static inline void PushByteCode(const void* bytecode, u32 bytecodelen, PSCacheEntry* entry);
	typedef std::unordered_map<PixelShaderUid, PSCacheEntry, PixelShaderUid::ShaderUidHasher> PSCache;

	static PSCache s_pixel_shaders;
	static const PSCacheEntry* s_last_entry;
	static PixelShaderUid s_last_uid;
	static PixelShaderUid s_external_last_uid;
	static UidChecker<PixelShaderUid,ShaderCode> s_pixel_uid_checker;
};

}  // namespace DX11
