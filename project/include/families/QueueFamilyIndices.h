#ifndef SPOOPY_QUEUE_FAMILY_INDICES_H
#define SPOOPY_QUEUE_FAMILY_INDICES_H

#include <vector>

#include <SpoopyHelpers.h>

namespace spoopy {
    class QueueFamilyIndices {
        public:
            #ifdef SPOOPY_VULKAN 
            QueueFamilyIndices(std::vector<VkQueueFamilyProperties> queues);
            #else
            QueueFamilyIndices(uint32_t queues);
            #endif
        private:
            uint32_t graphicsFamily = 0;
            uint32_t presentFamily = 0;
            uint32_t computeFamily = 0;
            uint32_t transferFamily = 0;

            #ifdef SPOOPY_VULKAN
            VkQueueFlags supportedQueues = {};

            VkQueue graphicsQueue = VK_NULL_HANDLE;
            VkQueue presentQueue = VK_NULL_HANDLE;
            VkQueue computeQueue = VK_NULL_HANDLE;
            VkQueue transferQueue = VK_NULL_HANDLE;
            #endif
    };
}
#endif