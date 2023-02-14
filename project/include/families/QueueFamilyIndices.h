#pragma once

#include <helpers/SpoopyHelpers.h>

#include <vector>

namespace lime {
    class QueueFamilyIndices {
        public:
            #ifdef SPOOPY_VULKAN 
            QueueFamilyIndices(std::vector<VkQueueFamilyProperties> queues);
            #else
            QueueFamilyIndices(uint32_t queues);
            #endif

            #ifdef SPOOPY_VULKAN
            virtual void createQueueInfos();
            virtual void getLogicalDeviceQueuesVulkan(VkDevice _device);
            #endif

            uint32_t graphicsFamily = 0;
            uint32_t presentFamily = 0;
            uint32_t computeFamily = 0;
            uint32_t transferFamily = 0;

            #ifdef SPOOPY_VULKAN
            std::vector<VkDeviceQueueCreateInfo> queueCreateInfos;
            #endif
        private:
            #ifdef SPOOPY_VULKAN
            VkQueueFlags supportedQueues = {};

            VkQueue graphicsQueue = VK_NULL_HANDLE;
            VkQueue presentQueue = VK_NULL_HANDLE;
            VkQueue computeQueue = VK_NULL_HANDLE;
            VkQueue transferQueue = VK_NULL_HANDLE;
            #endif
    };
}