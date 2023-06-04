#pragma once

#include <core/Log.h>
#include <spoopy.h>

#ifdef SPOOPY_SDL
    #include <SDL.h>
    #include <SDL_vulkan.h>
#endif

namespace lime {
    void checkVulkan(VkResult result);
    std::string stringifyResultVk(VkResult result);
}