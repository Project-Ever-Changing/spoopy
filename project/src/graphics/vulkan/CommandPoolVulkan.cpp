#include "GraphicsVulkan.h"
#include "CommandPoolVulkan.h"

namespace lime { namespace spoopy {
    CommandPoolVulkan::CommandPoolVulkan(const LogicalDevice &device, uint32_t queueFamily) {
        VkCommandPoolCreateInfo commandPoolCreateInfo = {};
        commandPoolCreateInfo.sType = VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO;
        commandPoolCreateInfo.flags = VK_COMMAND_POOL_CREATE_TRANSIENT_BIT | VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT;
        commandPoolCreateInfo.queueFamilyIndex = queueFamily;
        checkVulkan(vkCreateCommandPool(device, &commandPoolCreateInfo, nullptr, &commandPool));
    }

    CommandPoolVulkan::~CommandPoolVulkan() {
        auto device = GraphicsVulkan::GetCurrent()->GetLogicalDevice();
        vkDestroyCommandPool(*device, commandPool, nullptr);
    }
}}