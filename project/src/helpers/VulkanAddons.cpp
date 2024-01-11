#include "VulkanAddons.h"
#include "SpoopyHelpersVulkan.h"

#include <iostream>

namespace lime { namespace spoopy {
    #if SPOOPY_DEBUG_MESSENGER

    VkResult FvkCreateDebugUtilsMessengerEXT(VkInstance instance, const VkDebugUtilsMessengerCreateInfoEXT *pCreateInfo,
    const VkAllocationCallbacks *pAllocator, VkDebugUtilsMessengerEXT *pDebugMessenger) {
        auto func = reinterpret_cast<PFN_vkCreateDebugUtilsMessengerEXT>(vkGetInstanceProcAddr(instance, "vkCreateDebugUtilsMessengerEXT"));

        if(func) {
            return func(instance, pCreateInfo, pAllocator, pDebugMessenger);
        }

        return VK_ERROR_EXTENSION_NOT_PRESENT;
    }

    void FvkDestroyDebugUtilsMessengerEXT(VkInstance instance, VkDebugUtilsMessengerEXT messenger, const VkAllocationCallbacks *pAllocator) {
        auto func = reinterpret_cast<PFN_vkDestroyDebugUtilsMessengerEXT>(vkGetInstanceProcAddr(instance, "vkDestroyDebugUtilsMessengerEXT"));

        if(func) {
            func(instance, messenger, pAllocator);
        }
    }

    #else

    VkResult FvkCreateDebugReportCallbackEXT(VkInstance instance, const VkDebugReportCallbackCreateInfoEXT *pCreateInfo,
    const VkAllocationCallbacks *pAllocator, VkDebugReportCallbackEXT *pCallback) {
        auto func = reinterpret_cast<PFN_vkCreateDebugReportCallbackEXT>(vkGetInstanceProcAddr(instance, "vkCreateDebugReportCallbackEXT"));

        if (func) {
            return func(instance, pCreateInfo, pAllocator, pCallback);
        }

        return VK_ERROR_EXTENSION_NOT_PRESENT;
    }

    void FvkDestroyDebugReportCallbackEXT(VkInstance instance, VkDebugReportCallbackEXT callback, const VkAllocationCallbacks *pAllocator) {
        auto func = reinterpret_cast<PFN_vkDestroyDebugReportCallbackEXT>(vkGetInstanceProcAddr(instance, "vkDestroyDebugReportCallbackEXT"));

        if (func) {
            func(instance, callback, pAllocator);
        }
    }

    #endif

    void FvkCmdPushDescriptorSetKHR(VkDevice device, VkCommandBuffer commandBuffer, VkPipelineBindPoint pipelineBindPoint, VkPipelineLayout layout, uint32_t set,
    uint32_t descriptorWriteCount, const VkWriteDescriptorSet *pDescriptorWrites) {
        auto func = reinterpret_cast<PFN_vkCmdPushDescriptorSetKHR>(vkGetDeviceProcAddr(device, "vkCmdPushDescriptorSetKHR"));

        if(func) {
            func(commandBuffer, pipelineBindPoint, layout, set, descriptorWriteCount, pDescriptorWrites);
        }
    }

    uint32_t FindMemoryTypeIndex(const VkPhysicalDeviceMemoryProperties *deviceMemoryProperties, const VkMemoryRequirements *memoryRequirements,
    VkMemoryPropertyFlags requiredProperties) {
        for (uint32_t i = 0; i < deviceMemoryProperties->memoryTypeCount; ++i) {
            if (memoryRequirements->memoryTypeBits & (1 << i)) {
                if ((deviceMemoryProperties->memoryTypes[i].propertyFlags & requiredProperties) == requiredProperties) {
                    return i;
                }
            }
        }

        throw std::runtime_error("Couldn't find a proper memory type");
    }

    #ifdef HX_MACOS

    void FvkCreateMacOSSurfaceMVK(VkInstance instance, const VkMacOSSurfaceCreateInfoMVK *pCreateInfo, const VkAllocationCallbacks *pAllocator
    , VkSurfaceKHR *pSurface) {
        auto func = reinterpret_cast<PFN_vkCreateMacOSSurfaceMVK>(vkGetInstanceProcAddr(instance, "vkCreateMacOSSurfaceMVK"));

        if(func) {
            checkVulkan(func(instance, pCreateInfo, pAllocator, pSurface));
        }
    }

    #endif
}}