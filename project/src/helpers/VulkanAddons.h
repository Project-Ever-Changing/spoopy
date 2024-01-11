#pragma once

#include <spoopy.h>

#ifndef SPOOPY_ENGINE_VERSION
#define SPOOPY_ENGINE_VERSION VK_MAKE_VERSION(0, 0, 1)
#endif

#ifndef VK_API_VERSION_1_1
#define VK_API_VERSION_1_1 VK_MAKE_API_VERSION(0, 1, 1, 0)
#endif

#ifndef VK_API_VERSION_1_3_2
#define VK_API_VERSION_1_3_2 VK_MAKE_VERSION(1, 3, 2)
#endif

#ifndef VMA_DEDICATED_ALLOCATION
#define VMA_DEDICATED_ALLOCATION 0
#endif

#define SPOOPY_DEBUG_MESSENGER VK_HEADER_VERSION >= 121

namespace lime { namespace spoopy {
    #if SPOOPY_DEBUG_MESSENGER

    VkResult FvkCreateDebugUtilsMessengerEXT(VkInstance instance, const VkDebugUtilsMessengerCreateInfoEXT *pCreateInfo,
    const VkAllocationCallbacks *pAllocator, VkDebugUtilsMessengerEXT *pDebugMessenger);
    void FvkDestroyDebugUtilsMessengerEXT(VkInstance instance, VkDebugUtilsMessengerEXT messenger, const VkAllocationCallbacks *pAllocator);

    #else

    VkResult FvkCreateDebugReportCallbackEXT(VkInstance instance, const VkDebugReportCallbackCreateInfoEXT *pCreateInfo,
    const VkAllocationCallbacks *pAllocator, VkDebugReportCallbackEXT *pCallback);
    void FvkDestroyDebugReportCallbackEXT(VkInstance instance, VkDebugReportCallbackEXT callback, const VkAllocationCallbacks *pAllocator);

    #endif

    void FvkCmdPushDescriptorSetKHR(VkDevice device, VkCommandBuffer commandBuffer, VkPipelineBindPoint pipelineBindPoint, VkPipelineLayout layout, uint32_t set,
    uint32_t descriptorWriteCount, const VkWriteDescriptorSet *pDescriptorWrites);

    uint32_t FindMemoryTypeIndex(const VkPhysicalDeviceMemoryProperties *deviceMemoryProperties, const VkMemoryRequirements *memoryRequirements,
    VkMemoryPropertyFlags requiredProperties);

    #ifdef HX_MACOS

    void FvkCreateMacOSSurfaceMVK(VkInstance instance, const VkMacOSSurfaceCreateInfoMVK *pCreateInfo, const VkAllocationCallbacks *pAllocator
    , VkSurfaceKHR *pSurface);

    #endif
}}