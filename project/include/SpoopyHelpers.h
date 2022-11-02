#ifndef SPOOPY_HELPERS_CPP
#define SPOOPY_HELPERS_CPP

#include <iostream>

#ifdef SPOOPY_VULKAN
    #ifdef SPOOPY_SDL
        #include <SDL_vulkan.h>
    #endif
    
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

    VkResult FvkCreateDebugUtilsMessengerEXT(VkInstance instance, const VkDebugUtilsMessengerCreateInfoEXT *pCreateInfo, 
	const VkAllocationCallbacks *pAllocator, VkDebugUtilsMessengerEXT *pDebugMessenger);
    VkResult FvkCreateDebugReportCallbackEXT(VkInstance instance, const VkDebugReportCallbackCreateInfoEXT *pCreateInfo,
    const VkAllocationCallbacks *pAllocator, VkDebugReportCallbackEXT *pCallback);

    void FvkDestroyDebugUtilsMessengerEXT(VkInstance instance, VkDebugUtilsMessengerEXT messenger, const VkAllocationCallbacks *pAllocator);
    void FvkDestroyDebugReportCallbackEXT(VkInstance instance, VkDebugReportCallbackEXT callback, const VkAllocationCallbacks *pAllocator);

    VkSampleCountFlagBits getMaxUsableSampleCount(VkPhysicalDevice &physicalDevice);
    #endif
}
#endif