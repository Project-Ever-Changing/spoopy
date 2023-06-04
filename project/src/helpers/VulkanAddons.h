#pragma once

#include <volk.h>

#ifndef SPOOPY_ENGINE_VERSION
#define SPOOPY_ENGINE_VERSION VK_MAKE_VERSION(0, 0, 1)
#endif

#ifndef VK_API_VERSION_1_1
#define VK_API_VERSION_1_1 VK_MAKE_VERSION(1, 1, 0)
#endif

#define SPOOPY_DEBUG_MESSENGER VK_HEADER_VERSION >= 121

namespace lime {
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
}