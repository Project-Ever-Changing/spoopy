#ifndef SPOOPY_HELPERS_CPP
#define SPOOPY_HELPERS_CPP

#include <iostream>

#ifdef SPOOPY_VULKAN
    #include <SDL_vulkan.h>
    #include <vulkan/vulkan.h>
    #include <vulkan/vulkan_core.h>

    #ifdef SPOOPY_WIN32
        #include <vulkan/vulkan_win32.h>
    #endif
#endif

#include <core/Log.h>

namespace spoopy {
    #ifdef SPOOPY_VULKAN
    void checkVulkan(VkResult result);
    std::string stringifyResultVk(VkResult result);
    #endif
}
#endif