// Copyright 2013 Dolphin Emulator Project
// Licensed under GPLv2+
// Refer to the license.txt file included.

#include "VideoCommon/VideoBackendBase.h"

// TODO: ugly
#ifdef _WIN32
#include "VideoBackends/DX9/VideoBackend.h"
#include "VideoBackends/DX11/VideoBackend.h"
#endif
#include "VideoBackends/OGL/VideoBackend.h"
#include "VideoBackends/Software/VideoBackend.h"

std::vector<VideoBackend*> g_available_video_backends;
VideoBackend* g_video_backend = nullptr;
static VideoBackend* s_default_backend = nullptr;

#ifdef _WIN32
#include <windows.h>

// http://msdn.microsoft.com/en-us/library/ms725491.aspx
static bool IsGteVista() 
{
	OSVERSIONINFOEX osvi;
	DWORDLONG dwlConditionMask = 0;

	ZeroMemory(&osvi, sizeof(OSVERSIONINFOEX));
	osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFOEX);
	osvi.dwMajorVersion = 6;

	VER_SET_CONDITION(dwlConditionMask, VER_MAJORVERSION, VER_GREATER_EQUAL);

	return VerifyVersionInfo(&osvi, VER_MAJORVERSION, dwlConditionMask) != FALSE;
}
// Nvidia drivers >= v302 will check if the application exports a global
// variable named NvOptimusEnablement to know if it should run the app in high
// performance graphics mode or using the IGP.
extern "C" {
	__declspec(dllexport) DWORD NvOptimusEnablement = 1;
}
#endif

void VideoBackend::PopulateList()
{
	VideoBackend* backends[4] = { NULL };

	// D3D9 > D3D11 > OGL > SW
#ifdef _WIN32
	g_available_video_backends.push_back(backends[0] = new DX9::VideoBackend);
	if (IsGteVista())
		g_available_video_backends.push_back(backends[1] = new DX11::VideoBackend);
#endif
// disable OGL video Backend while is merged from master
#if !defined(USE_GLES) || USE_GLES3
	g_available_video_backends.push_back(backends[2] = new OGL::VideoBackend);
#endif
	g_available_video_backends.push_back(backends[3] = new SW::VideoSoftware);

	for (int i = 0; i < 4; ++i)
	{
		if (backends[i])
		{
			s_default_backend = g_video_backend = backends[i];
			break;
		}
	}
}

void VideoBackend::ClearList()
{
	while (!g_available_video_backends.empty())
	{
		delete g_available_video_backends.back();
		g_available_video_backends.pop_back();
	}
}

void VideoBackend::ActivateBackend(const std::string& name)
{
	if (name.length() == 0) // If nullptr, set it to the default backend (expected behavior)
		g_video_backend = s_default_backend;

	for (VideoBackend* backend : g_available_video_backends)
		if (name == backend->GetName())
			g_video_backend = backend;;
}
