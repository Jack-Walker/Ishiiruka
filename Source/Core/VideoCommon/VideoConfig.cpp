// Copyright 2013 Dolphin Emulator Project
// Licensed under GPLv2+
// Refer to the license.txt file included.

#include <cmath>

#include "Common/CommonTypes.h"
#include "Common/FileUtil.h"
#include "Common/IniFile.h"
#include "Common/StringUtil.h"
#include "Core/ConfigManager.h"
#include "Core/Core.h"
#include "Core/Movie.h"
#include "VideoCommon/OnScreenDisplay.h"
#include "VideoCommon/NativeVertexFormat.h"
#include "VideoCommon/VideoCommon.h"
#include "VideoCommon/VideoConfig.h"

VideoConfig g_Config;
VideoConfig g_ActiveConfig;

void UpdateActiveConfig()
{
	if (Movie::IsPlayingInput() && Movie::IsConfigSaved())
		Movie::SetGraphicsConfig();
	g_ActiveConfig = g_Config;
}

VideoConfig::VideoConfig()
{
	bRunning = false;

	// Exclusive fullscreen flags
	bFullscreen = false;
	bExclusiveMode = false;

	// Needed for the first frame, I think
	fAspectRatioHackW = 1;
	fAspectRatioHackH = 1;

	// disable all features by default
	backend_info.APIType = API_NONE;
	for (s32 i = 0; i < 16; i++)
	{
		backend_info.bSupportedFormats[i] = false;
	}
	backend_info.bSupportsExclusiveFullscreen = false;

	// Game-specific stereoscopy settings
	bStereoEFBMonoDepth = false;
	iStereoDepthPercentage = 100;
	iStereoConvergenceMinimum = 0;
	bUseScalingFilter = false;
	bTexDeposterize = false;
	iTexScalingType = 0;
	iTexScalingFactor = 2;
}

void VideoConfig::Load(const std::string& ini_file)
{
	IniFile iniFile;
	iniFile.Load(ini_file);

	IniFile::Section* hardware = iniFile.GetOrCreateSection("Hardware");
	hardware->Get("VSync", &bVSync, 0);
	hardware->Get("Adapter", &iAdapter, 0);

	IniFile::Section* settings = iniFile.GetOrCreateSection("Settings");
	settings->Get("wideScreenHack", &bWidescreenHack, false);
	settings->Get("AspectRatio", &iAspectRatio, (int)ASPECT_AUTO);
	settings->Get("Crop", &bCrop, false);
	settings->Get("UseXFB", &bUseXFB, 0);
	settings->Get("UseRealXFB", &bUseRealXFB, 0);
	settings->Get("SafeTextureCacheColorSamples", &iSafeTextureCache_ColorSamples, 128);
	settings->Get("ShowFPS", &bShowFPS, false);
	settings->Get("LogRenderTimeToFile", &bLogRenderTimeToFile, false);
	settings->Get("ShowInputDisplay", &bShowInputDisplay, false);
	settings->Get("OverlayStats", &bOverlayStats, false);
	settings->Get("OverlayProjStats", &bOverlayProjStats, false);
	settings->Get("DumpTextures", &bDumpTextures, 0);
	settings->Get("DumpVertexLoader", &bDumpVertexLoaders, 0);
	settings->Get("HiresTextures", &bHiresTextures, 0);
	settings->Get("HiresMaterialMaps", &bHiresMaterialMaps, 0);
	settings->Get("ConvertHiresTextures", &bConvertHiresTextures, 0);
	settings->Get("CacheHiresTextures", &bCacheHiresTextures, 0);
	settings->Get("CacheHiresTexturesonGPU", &bCacheHiresTexturesGPU, 0);
	settings->Get("DumpEFBTarget", &bDumpEFBTarget, 0);
	settings->Get("FreeLook", &bFreeLook, 0);
	settings->Get("UseFFV1", &bUseFFV1, 0);
	settings->Get("EnablePixelLighting", &bEnablePixelLighting, 0);
	settings->Get("ForcePhongShading", &bForcePhongShading, 0);
	
	
	settings->Get("FastDepthCalc", &bFastDepthCalc, true);
	settings->Get("MSAA", &iMultisampleMode, 0);
	settings->Get("EFBScale", &iEFBScale, (int)SCALE_1X); // native	
	settings->Get("TexFmtOverlayEnable", &bTexFmtOverlayEnable, 0);
	settings->Get("TexFmtOverlayCenter", &bTexFmtOverlayCenter, 0);
	settings->Get("WireFrame", &bWireFrame, 0);
	settings->Get("DisableFog", &bDisableFog, 0);
	settings->Get("SSAA", &bSSAA, false);
	settings->Get("EnableOpenCL", &bEnableOpenCL, false);
	settings->Get("EnableShaderDebugging", &bEnableShaderDebugging, false);
	settings->Get("BorderlessFullscreen", &bBorderlessFullscreen, false);

	IniFile::Section* enhancements = iniFile.GetOrCreateSection("Enhancements");
	enhancements->Get("ForceFiltering", &bForceFiltering, 0);
	enhancements->Get("MaxAnisotropy", &iMaxAnisotropy, 0);  // NOTE - this is x in (1 << x)
	enhancements->Get("PostProcessingShader", &sPostProcessingShader, "");
	enhancements->Get("StereoMode", &iStereoMode, 0);
	enhancements->Get("StereoDepth", &iStereoDepth, 20);
	enhancements->Get("StereoConvergence", &iStereoConvergence, 20);
	enhancements->Get("StereoSwapEyes", &bStereoSwapEyes, false);
	enhancements->Get("UseScalingFilter", &bUseScalingFilter, false);
	enhancements->Get("TextureScalingType", &iTexScalingType, 0);
	enhancements->Get("TextureScalingFactor", &iTexScalingFactor, 2);
	enhancements->Get("UseDePosterize", &bTexDeposterize, false);
	enhancements->Get("Tessellation", &bTessellation, 0);
	enhancements->Get("TessellationMin", &iTessellationMin, 1);
	enhancements->Get("TessellationMax", &iTessellationMax, 6);
	enhancements->Get("TessellationRoundingIntensity", &iTessellationRoundingIntensity, 0);
	enhancements->Get("TessellationDisplacementIntensity", &iTessellationDisplacementIntensity, 0);
	
	//currently these settings are not saved in global config, so we could've initialized them directly
	for (size_t i = 0; i < oStereoPresets.size(); ++i)
	{
	   enhancements->Get(StringFromFormat("StereoConvergence_%zu", i), &oStereoPresets[i].depth, iStereoConvergence);
	   enhancements->Get(StringFromFormat("StereoDepth_%zu", i), &oStereoPresets[i].convergence, iStereoDepth);
	}
	enhancements->Get("StereoActivePreset", &iStereoActivePreset, 0);
	iStereoConvergence = oStereoPresets[iStereoActivePreset].convergence;
	iStereoDepth = oStereoPresets[iStereoActivePreset].depth;

	IniFile::Section* hacks = iniFile.GetOrCreateSection("Hacks");
	hacks->Get("EFBAccessEnable", &bEFBAccessEnable, true);
	hacks->Get("EFBFastAccess", &bEFBFastAccess, false);
	hacks->Get("ForceProgressive", &bForceProgressive, true);
	hacks->Get("EFBToTextureEnable", &bSkipEFBCopyToRam, true);
	hacks->Get("EFBScaledCopy", &bCopyEFBScaled, true);
	hacks->Get("EFBEmulateFormatChanges", &bEFBEmulateFormatChanges, false);
	hacks->Get("ForceDualSourceBlend", &bForceDualSourceBlend, false);
	hacks->Get("FullAsyncShaderCompilation", &bFullAsyncShaderCompilation, false);
	hacks->Get("WaitForShaderCompilation", &bWaitForShaderCompilation, false);
	hacks->Get("PredictiveFifo", &bPredictiveFifo, false);
	hacks->Get("BoundingBoxMode", &iBBoxMode, (int)BBoxMode::BBoxGPU);

	// hacks which are disabled by default
	iPhackvalue[0] = 0;
	bPerfQueriesEnable = false;

	// Load common settings
	iniFile.Load(File::GetUserPath(F_DOLPHINCONFIG_IDX));
	IniFile::Section* interface = iniFile.GetOrCreateSection("Interface");
	bool bTmp;
	interface->Get("UsePanicHandlers", &bTmp, true);
	SetEnableAlert(bTmp);

	// Shader Debugging causes a huge slowdown and it's easy to forget about it
	// since it's not exposed in the settings dialog. It's only used by
	// developers, so displaying an obnoxious message avoids some confusion and
	// is not too annoying/confusing for users.
	//
	// XXX(delroth): This is kind of a bad place to put this, but the current
	// VideoCommon is a mess and we don't have a central initialization
	// function to do these kind of checks. Instead, the init code is
	// triplicated for each video backend.
	if (bEnableShaderDebugging)
		OSD::AddMessage("Warning: Shader Debugging is enabled, performance will suffer heavily", 15000);
	VerifyValidity();
}

void VideoConfig::GameIniLoad()
{
	bool gfx_override_exists = false;

	// XXX: Again, bad place to put OSD messages at (see delroth's comment above)
	// XXX: This will add an OSD message for each projection hack value... meh
#define CHECK_SETTING(section, key, var) do { \
		decltype(var) temp = var; \
		if (iniFile.GetIfExists(section, key, &var) && var != temp) { \
			std::string msg = StringFromFormat("Note: Option \"%s\" is overridden by game ini.", key); \
			OSD::AddMessage(msg, 7500); \
			gfx_override_exists = true; \
		} \
	} while (0)

	IniFile iniFile = SConfig::GetInstance().LoadGameIni();

	CHECK_SETTING("Video_Hardware", "VSync", bVSync);

	CHECK_SETTING("Video_Settings", "wideScreenHack", bWidescreenHack);
	CHECK_SETTING("Video_Settings", "AspectRatio", iAspectRatio);
	CHECK_SETTING("Video_Settings", "Crop", bCrop);
	CHECK_SETTING("Video_Settings", "UseXFB", bUseXFB);
	CHECK_SETTING("Video_Settings", "UseRealXFB", bUseRealXFB);
	CHECK_SETTING("Video_Settings", "SafeTextureCacheColorSamples", iSafeTextureCache_ColorSamples);
	CHECK_SETTING("Video_Settings", "HiresTextures", bHiresTextures);
	CHECK_SETTING("Video_Settings", "HiresMaterialMaps", bHiresMaterialMaps);

	CHECK_SETTING("Video_Settings", "ConvertHiresTextures", bConvertHiresTextures);
	CHECK_SETTING("Video_Settings", "CacheHiresTextures", bCacheHiresTextures);
	CHECK_SETTING("Video_Settings", "CacheHiresTexturesonGPU", bCacheHiresTexturesGPU);
	CHECK_SETTING("Video_Settings", "EnablePixelLighting", bEnablePixelLighting);
	CHECK_SETTING("Video_Settings", "ForcePhongShading", bForcePhongShading);
	
	
	CHECK_SETTING("Video_Settings", "FastDepthCalc", bFastDepthCalc);
	CHECK_SETTING("Video_Settings", "MSAA", iMultisampleMode);
	CHECK_SETTING("Video_Settings", "SSAA", bSSAA);
	int tmp = -9000;
	CHECK_SETTING("Video_Settings", "EFBScale", tmp); // integral
	if (tmp != -9000)
	{
		if (tmp != SCALE_FORCE_INTEGRAL)
		{
			iEFBScale = tmp;
		}
		else // Round down to multiple of native IR
		{
			switch (iEFBScale)
			{
			case SCALE_AUTO:
				iEFBScale = SCALE_AUTO_INTEGRAL;
				break;
			case SCALE_1_5X:
				iEFBScale = SCALE_1X;
				break;
			case SCALE_2_5X:
				iEFBScale = SCALE_2X;
				break;
			default:
				break;
			}
		}
	}

	CHECK_SETTING("Video_Settings", "DisableFog", bDisableFog);
	CHECK_SETTING("Video_Settings", "EnableOpenCL", bEnableOpenCL);

	CHECK_SETTING("Video_Enhancements", "ForceFiltering", bForceFiltering);
	CHECK_SETTING("Video_Enhancements", "MaxAnisotropy", iMaxAnisotropy);  // NOTE - this is x in (1 << x)
	CHECK_SETTING("Video_Enhancements", "PostProcessingShader", sPostProcessingShader);
	CHECK_SETTING("Video_Enhancements", "StereoMode", iStereoMode);
	CHECK_SETTING("Video_Enhancements", "StereoDepth", iStereoDepth);
	CHECK_SETTING("Video_Enhancements", "StereoConvergence", iStereoConvergence);
	CHECK_SETTING("Video_Enhancements", "StereoSwapEyes", bStereoSwapEyes);
	CHECK_SETTING("Video_Enhancements", "UseScalingFilter", bUseScalingFilter);
	CHECK_SETTING("Video_Enhancements", "TextureScalingType", iTexScalingType);
	CHECK_SETTING("Video_Enhancements", "TextureScalingFactor", iTexScalingFactor);
	CHECK_SETTING("Video_Enhancements", "UseDePosterize", bTexDeposterize);
	CHECK_SETTING("Video_Enhancements", "Tessellation", bTessellation);
	CHECK_SETTING("Video_Enhancements", "TessellationMin", iTessellationMin);
	CHECK_SETTING("Video_Enhancements", "TessellationMax", iTessellationMax);
	CHECK_SETTING("Video_Enhancements", "TessellationRoundingIntensity", iTessellationRoundingIntensity);
	CHECK_SETTING("Video_Enhancements", "TessellationDisplacementIntensity", iTessellationDisplacementIntensity);
	
	//these are not overrides, they are per-game settings, hence no warning
	IniFile::Section* enhancements = iniFile.GetOrCreateSection("Enhancements");
	for (size_t i = 0; i < oStereoPresets.size(); ++i)
	{
	   enhancements->Get(StringFromFormat("StereoConvergence_%zu", i), &oStereoPresets[i].depth, iStereoConvergence);
	   enhancements->Get(StringFromFormat("StereoDepth_%zu", i), &oStereoPresets[i].convergence, iStereoDepth);
	}
	enhancements->Get("StereoActivePreset", &iStereoActivePreset, 0);
	iStereoConvergence = oStereoPresets[iStereoActivePreset].convergence;
	iStereoDepth = oStereoPresets[iStereoActivePreset].depth;


	CHECK_SETTING("Video_Stereoscopy", "StereoEFBMonoDepth", bStereoEFBMonoDepth);
	CHECK_SETTING("Video_Stereoscopy", "StereoDepthPercentage", iStereoDepthPercentage);
	CHECK_SETTING("Video_Stereoscopy", "StereoConvergenceMinimum", iStereoConvergenceMinimum);

	CHECK_SETTING("Video_Hacks", "EFBAccessEnable", bEFBAccessEnable);
	CHECK_SETTING("Video_Hacks", "EFBFastAccess", bEFBFastAccess);
	CHECK_SETTING("Video_Hacks", "ForceProgressive", bForceProgressive);
	CHECK_SETTING("Video_Hacks", "EFBToTextureEnable", bSkipEFBCopyToRam);
	CHECK_SETTING("Video_Hacks", "EFBScaledCopy", bCopyEFBScaled);
	CHECK_SETTING("Video_Hacks", "EFBEmulateFormatChanges", bEFBEmulateFormatChanges);
	CHECK_SETTING("Video_Hacks", "BoundingBoxMode", iBBoxMode);

	CHECK_SETTING("Video", "ProjectionHack", iPhackvalue[0]);
	CHECK_SETTING("Video", "PH_SZNear", iPhackvalue[1]);
	CHECK_SETTING("Video", "PH_SZFar", iPhackvalue[2]);
	CHECK_SETTING("Video", "PH_ExtraParam", iPhackvalue[3]);
	CHECK_SETTING("Video", "PH_ZNear", sPhackvalue[0]);
	CHECK_SETTING("Video", "PH_ZFar", sPhackvalue[1]);
	CHECK_SETTING("Video", "PerfQueriesEnable", bPerfQueriesEnable);
	CHECK_SETTING("Video", "FullAsyncShaderCompilation", bFullAsyncShaderCompilation);
	CHECK_SETTING("Video", "WaitForShaderCompilation", bWaitForShaderCompilation);
	CHECK_SETTING("Video", "PredictiveFifo", bPredictiveFifo);
	if (gfx_override_exists)
		OSD::AddMessage("Warning: Opening the graphics configuration will reset settings and might cause issues!", 10000);
}

void VideoConfig::VerifyValidity()
{
	// Disable while is unstable
	bEnableOpenCL = false;
	// TODO: Check iMaxAnisotropy value
	if (iAdapter < 0 || iAdapter >((int)backend_info.Adapters.size() - 1)) iAdapter = 0;
	if (iMultisampleMode < 0 || iMultisampleMode >= (int)backend_info.AAModes.size()) iMultisampleMode = 0;
	if (!backend_info.bSupportsPixelLighting) bEnablePixelLighting = false;
	bForcePhongShading = bForcePhongShading && bEnablePixelLighting;
	iTessellationMax = iTessellationMax < 2 ? 2 : (iTessellationMax > 63 ? 63 : iTessellationMax);
	iTessellationMin = iTessellationMin < 1 ? 1 : (iTessellationMin > iTessellationMax ? iTessellationMax : iTessellationMin);
	iTessellationRoundingIntensity = iTessellationRoundingIntensity > 100 ? 100 : (iTessellationRoundingIntensity < 0 ? 0 : iTessellationRoundingIntensity);
	iTessellationDisplacementIntensity = iTessellationDisplacementIntensity > 300 ? 300 : (iTessellationDisplacementIntensity < 0 ? 0 : iTessellationDisplacementIntensity);
	if (iStereoMode > 0)
	{
		if (!backend_info.bSupportsGeometryShaders)
		{
			OSD::AddMessage("Stereoscopic 3D isn't supported by your GPU, support for OpenGL 3.2 is required.", 10000);
			iStereoMode = 0;
		}
		if (bUseXFB && bUseRealXFB)
		{
			OSD::AddMessage("Stereoscopic 3D isn't supported with Real XFB, turning off stereoscopy.", 10000);
			iStereoMode = 0;
		}
	}
	if (backend_info.APIType == API_OPENGL)
	{
		//disable until is properly implemneted
		bPredictiveFifo = false;
		bFullAsyncShaderCompilation = false;
		bWaitForShaderCompilation = false;
	}
	if (iBBoxMode > BBoxGPU || iBBoxMode < BBoxNone)
	{
		iBBoxMode = BBoxGPU;
	}
	if (backend_info.APIType & API_D3D9 && iBBoxMode == BBoxGPU)
	{
		iBBoxMode = BBoxCPU;
	}
	if (iTexScalingFactor < 2)
	{
		iTexScalingFactor = 2;
	}
	else if (iTexScalingFactor > 5)
	{
		iTexScalingFactor = 5;
	}
	if (iTexScalingType < 0)
	{
		iTexScalingType = 0;
	}
	else if (iTexScalingType > 4)
	{
		iTexScalingType = 4;
	}
	bHiresMaterialMaps = bHiresMaterialMaps && bHiresTextures && bEnablePixelLighting;
}

void VideoConfig::Save(const std::string& ini_file)
{
	IniFile iniFile;
	iniFile.Load(ini_file);

	IniFile::Section* hardware = iniFile.GetOrCreateSection("Hardware");
	hardware->Set("VSync", bVSync);
	hardware->Set("Adapter", iAdapter);

	IniFile::Section* settings = iniFile.GetOrCreateSection("Settings");
	settings->Set("AspectRatio", iAspectRatio);
	settings->Set("Crop", bCrop);
	settings->Set("wideScreenHack", bWidescreenHack);
	settings->Set("UseXFB", bUseXFB);
	settings->Set("UseRealXFB", bUseRealXFB);
	settings->Set("SafeTextureCacheColorSamples", iSafeTextureCache_ColorSamples);
	settings->Set("ShowFPS", bShowFPS);
	settings->Set("LogRenderTimeToFile", bLogRenderTimeToFile);
	settings->Set("ShowInputDisplay", bShowInputDisplay);
	settings->Set("OverlayStats", bOverlayStats);
	settings->Set("OverlayProjStats", bOverlayProjStats);
	settings->Set("DumpTextures", bDumpTextures);
	settings->Set("DumpVertexLoader", bDumpVertexLoaders);
	settings->Set("HiresTextures", bHiresTextures);
	settings->Set("HiresMaterialMaps", bHiresMaterialMaps);

	settings->Set("ConvertHiresTextures", bConvertHiresTextures);
	settings->Set("CacheHiresTextures", bCacheHiresTextures);
	settings->Set("CacheHiresTexturesonGPU", bCacheHiresTexturesGPU);
	settings->Set("DumpEFBTarget", bDumpEFBTarget);
	settings->Set("FreeLook", bFreeLook);
	settings->Set("UseFFV1", bUseFFV1);
	settings->Set("EnablePixelLighting", bEnablePixelLighting);
	settings->Set("ForcePhongShading", bForcePhongShading);
	
	
	settings->Set("FastDepthCalc", bFastDepthCalc);
	settings->Set("MSAA", iMultisampleMode);
	settings->Set("SSAA", bSSAA);
	settings->Set("EFBScale", iEFBScale);
	settings->Set("TexFmtOverlayEnable", bTexFmtOverlayEnable);
	settings->Set("TexFmtOverlayCenter", bTexFmtOverlayCenter);
	settings->Set("Wireframe", bWireFrame);
	settings->Set("DisableFog", bDisableFog);

	settings->Set("EnableOpenCL", bEnableOpenCL);
	settings->Set("EnableShaderDebugging", bEnableShaderDebugging);
	settings->Set("BorderlessFullscreen", bBorderlessFullscreen);

	IniFile::Section* enhancements = iniFile.GetOrCreateSection("Enhancements");
	enhancements->Set("ForceFiltering", bForceFiltering);
	enhancements->Set("MaxAnisotropy", iMaxAnisotropy);
	enhancements->Set("PostProcessingShader", sPostProcessingShader);
	enhancements->Set("StereoMode", iStereoMode);
	enhancements->Set("StereoDepth", iStereoDepth);
	enhancements->Set("StereoConvergence", iStereoConvergence);
	enhancements->Set("StereoSwapEyes", bStereoSwapEyes);
	enhancements->Set("UseScalingFilter", bUseScalingFilter);
	enhancements->Set("TextureScalingType", iTexScalingType);
	enhancements->Set("TextureScalingFactor", iTexScalingFactor);
	enhancements->Set("UseDePosterize", bTexDeposterize);
	enhancements->Set("Tessellation", bTessellation);
	enhancements->Set("TessellationMin", iTessellationMin);
	enhancements->Set("TessellationMax", iTessellationMax);
	enhancements->Set("TessellationRoundingIntensity", iTessellationRoundingIntensity);
	enhancements->Set("TessellationDisplacementIntensity", iTessellationDisplacementIntensity);
	
	IniFile::Section* hacks = iniFile.GetOrCreateSection("Hacks");
	hacks->Set("EFBAccessEnable", bEFBAccessEnable);
	hacks->Set("EFBFastAccess", bEFBFastAccess);
	hacks->Set("ForceProgressive", bForceProgressive);
	hacks->Set("EFBToTextureEnable", bSkipEFBCopyToRam);
	hacks->Set("EFBScaledCopy", bCopyEFBScaled);
	hacks->Set("EFBEmulateFormatChanges", bEFBEmulateFormatChanges);
	hacks->Set("ForceDualSourceBlend", bForceDualSourceBlend);
	hacks->Set("FullAsyncShaderCompilation", bFullAsyncShaderCompilation);
	hacks->Set("WaitForShaderCompilation", bWaitForShaderCompilation);
	hacks->Set("PredictiveFifo", bPredictiveFifo);
	hacks->Set("BoundingBoxMode", iBBoxMode);

	iniFile.Save(ini_file);
}

bool VideoConfig::IsVSync() const
{
	return bVSync && !Core::GetIsFramelimiterTempDisabled();
}

bool VideoConfig::PixelLightingEnabled(const XFMemory& xfr, const u32 components) const
{
	return (xfr.numChan.numColorChans > 0) && bEnablePixelLighting && backend_info.bSupportsPixelLighting && ((components & VB_HAS_NRM0) == VB_HAS_NRM0);
}
