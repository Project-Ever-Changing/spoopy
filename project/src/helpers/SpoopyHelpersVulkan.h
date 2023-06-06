#pragma once

#include <iostream>

#include <core/Log.h>
#include <spoopy.h>

#ifdef SPOOPY_SDL
    #include <SDL.h>
    #include <SDL_vulkan.h>
#endif

namespace lime { namespace spoopy {
    void checkVulkan(VkResult result);
    std::string stringifyResultVk(VkResult result);
}}