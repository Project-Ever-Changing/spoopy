#pragma once

#include <iostream>

#ifdef SPOOPY_VULKAN
    #ifdef SPOOPY_SDL
        #include <SDL_vulkan.h>
    #endif
    
    #ifdef SPOOPY_VOLK
        #include <volk.h>
    #endif
#endif

#include <core/Log.h>

namespace lime {
    #ifdef SPOOPY_VULKAN

    void checkVulkan(VkResult result);
    std::string stringifyResultVk(VkResult result);

    VkResult FvkCreateDebugUtilsMessengerEXT(VkInstance instance, const VkDebugUtilsMessengerCreateInfoEXT *pCreateInfo,
	const VkAllocationCallbacks *pAllocator, VkDebugUtilsMessengerEXT *pDebugMessenger);
    VkResult FvkCreateDebugReportCallbackEXT(VkInstance instance, const VkDebugReportCallbackCreateInfoEXT *pCreateInfo,
    const VkAllocationCallbacks *pAllocator, VkDebugReportCallbackEXT *pCallback);

    void FvkDestroyDebugUtilsMessengerEXT(VkInstance instance, VkDebugUtilsMessengerEXT messenger, const VkAllocationCallbacks *pAllocator);
    void FvkDestroyDebugReportCallbackEXT(VkInstance instance, VkDebugReportCallbackEXT callback, const VkAllocationCallbacks *pAllocator);

    void FvkCmdPushDescriptorSetKHR(VkDevice device, VkCommandBuffer commandBuffer, VkPipelineBindPoint pipelineBindPoint, VkPipelineLayout layout, uint32_t set,
		uint32_t descriptorWriteCount, const VkWriteDescriptorSet *pDescriptorWrites);

    uint32_t FindMemoryTypeIndex(const VkPhysicalDeviceMemoryProperties *deviceMemoryProperties, const VkMemoryRequirements *memoryRequirements,
		VkMemoryPropertyFlags requiredProperties);

    VkSampleCountFlagBits GetMaxUsableSampleCount(VkPhysicalDevice &physicalDevice);

    #endif
}