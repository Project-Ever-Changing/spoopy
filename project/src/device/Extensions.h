#pragma once

#ifndef VK_KHR_SURFACE_EXTENSION_NAME
#define VK_KHR_SURFACE_EXTENSION_NAME "VK_KHR_surface"
#endif


#ifdef _WIN32
#define VK_USE_PLATFORM_WIN32_KHR

#ifndef VK_KHR_WIN32_SURFACE_EXTENSION_NAME
#define VK_KHR_WIN32_SURFACE_EXTENSION_NAME "VK_KHR_win32_surface"
#endif

#endif


#ifdef __linux__

// For X11
#define VK_USE_PLATFORM_XLIB_KHR

#ifndef VK_KHR_XLIB_SURFACE_EXTENSION_NAME
#define VK_KHR_XLIB_SURFACE_EXTENSION_NAME "VK_KHR_xlib_surface"
#endif

// For XCB
#define VK_USE_PLATFORM_XCB_KHR

#ifndef VK_KHR_XCB_SURFACE_EXTENSION_NAME
#define VK_KHR_XCB_SURFACE_EXTENSION_NAME "VK_KHR_xcb_surface"
#endif

// For Wayland
#define VK_USE_PLATFORM_WAYLAND_KHR

#ifndef VK_KHR_WAYLAND_SURFACE_EXTENSION_NAME
#define VK_KHR_WAYLAND_SURFACE_EXTENSION_NAME "VK_KHR_wayland_surface"
#endif

#endif


#ifdef __ANDROID__
#define VK_USE_PLATFORM_ANDROID_KHR

#ifndef VK_KHR_ANDROID_SURFACE_EXTENSION_NAME
#define VK_KHR_ANDROID_SURFACE_EXTENSION_NAME "VK_KHR_android_surface"
#endif

#endif


#ifdef __APPLE__
#define VK_USE_PLATFORM_MACOS_MVK

// For MacOS
#ifndef VK_MVK_MACOS_SURFACE_EXTENSION_NAME
#define VK_MVK_MACOS_SURFACE_EXTENSION_NAME "VK_MVK_macos_surface"
#endif

// For iOS
#define VK_USE_PLATFORM_IOS_MVK

#ifndef VK_MVK_IOS_SURFACE_EXTENSION_NAME
#define VK_MVK_IOS_SURFACE_EXTENSION_NAME "VK_MVK_ios_surface"
#endif

#endif
