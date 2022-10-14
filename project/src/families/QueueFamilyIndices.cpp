#include <families/QueueFamilyIndices.h>

#include <optional>

namespace spoopy {
    #ifdef SPOOPY_VULKAN
    QueueFamilyIndices::QueueFamilyIndices(std::vector<VkQueueFamilyProperties> queues) {
        uint32_t queueMax = queues.size();
    #else
    QueueFamilyIndices::QueueFamilyIndices(uint32_t queues) {
        uint32_t queueMax = queues;
    #endif
        for (uint32_t i = 0; i < queueMax; i++) {
            #ifdef SPOOPY_VULKAN
            if (queues[i].queueFlags & VK_QUEUE_GRAPHICS_BIT) {
                graphicsFamily = i;
                this->graphicsFamily = i;
                supportedQueues |= VK_QUEUE_GRAPHICS_BIT;
            }

            if (queues[i].queueCount > 0) {
                presentFamily = i;
                this->presentFamily = i;
            }

            if (queues[i].queueFlags & VK_QUEUE_COMPUTE_BIT) {
                computeFamily = i;
                this->computeFamily = i;
                supportedQueues |= VK_QUEUE_COMPUTE_BIT;
            }

            if (queues[i].queueFlags & VK_QUEUE_TRANSFER_BIT) {
                transferFamily = i;
                this->transferFamily = i;
                supportedQueues |= VK_QUEUE_TRANSFER_BIT;
            }

            if (graphicsFamily && presentFamily && computeFamily && transferFamily) {
                break;
            }
            #endif
        }

        #ifdef SPOOPY_VULKAN
        if(graphicsFamily == 0) {
            throw std::runtime_error("Failed to find queue family!");
        }
        #endif
    }
}