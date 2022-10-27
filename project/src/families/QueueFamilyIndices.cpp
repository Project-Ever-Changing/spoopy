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

    #ifdef SPOOPY_VULKAN
    void QueueFamilyIndices::createQueueInfos() {
	    float queuePriorities[1] = {0.0f};

        if (supportedQueues & VK_QUEUE_GRAPHICS_BIT) {
            VkDeviceQueueCreateInfo graphicsQueueCreateInfo = {};
            graphicsQueueCreateInfo.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
            graphicsQueueCreateInfo.queueFamilyIndex = graphicsFamily;
            graphicsQueueCreateInfo.queueCount = 1;
            graphicsQueueCreateInfo.pQueuePriorities = queuePriorities;
            queueCreateInfos.emplace_back(graphicsQueueCreateInfo);
        } else {
            graphicsFamily = 0;
        }

        if (supportedQueues & VK_QUEUE_COMPUTE_BIT && computeFamily != graphicsFamily) {
            VkDeviceQueueCreateInfo computeQueueCreateInfo = {};
            computeQueueCreateInfo.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
            computeQueueCreateInfo.queueFamilyIndex = computeFamily;
            computeQueueCreateInfo.queueCount = 1;
            computeQueueCreateInfo.pQueuePriorities = queuePriorities;
            queueCreateInfos.emplace_back(computeQueueCreateInfo);
        } else {
            computeFamily = graphicsFamily;
        }

        if (supportedQueues & VK_QUEUE_TRANSFER_BIT && transferFamily != graphicsFamily && transferFamily != computeFamily) {
            VkDeviceQueueCreateInfo transferQueueCreateInfo = {};
            transferQueueCreateInfo.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
            transferQueueCreateInfo.queueFamilyIndex = transferFamily;
            transferQueueCreateInfo.queueCount = 1;
            transferQueueCreateInfo.pQueuePriorities = queuePriorities;
            queueCreateInfos.emplace_back(transferQueueCreateInfo);
        } else {
            transferFamily = graphicsFamily;
        }
    }

    void QueueFamilyIndices::getLogicalDeviceQueuesVulkan(VkDevice _device) {
        vkGetDeviceQueue(_device, graphicsFamily, 0, &graphicsQueue);
        vkGetDeviceQueue(_device, presentFamily, 0, &presentQueue);
        vkGetDeviceQueue(_device, computeFamily, 0, &computeQueue);
        vkGetDeviceQueue(_device, transferFamily, 0, &transferQueue);
    }
    #endif
}