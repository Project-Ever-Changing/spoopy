#pragma once

#include <iostream>

#include <graphics/PixelFormat.h>
#include <spoopy.h>

#ifdef SPOOPY_SDL
    #include <SDL.h>
    #include <SDL_vulkan.h>
#endif

namespace lime { namespace spoopy {
    void checkVulkan(const VkResult result);
    std::string stringifyResultVk(const VkResult result);
    VkFormat getFormatVk(const PixelFormat format);
}}