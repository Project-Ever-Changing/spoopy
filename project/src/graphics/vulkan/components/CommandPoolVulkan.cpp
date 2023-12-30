#include "../GraphicsVulkan.h"
#include "CommandPoolVulkan.h"

#include <spoopy_assert.h>

namespace lime { namespace spoopy {
    CommandPoolVulkan::CommandPoolVulkan(const LogicalDevice &device, uint32_t queueFamily)
    : GPUResource(device)
    , commandPool(handle) {
        VkCommandPoolCreateInfo commandPoolCreateInfo = {};
        commandPoolCreateInfo.sType = VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO;

        // I don't think VK_COMMAND_POOL_CREATE_TRANSIENT_BIT is needed,
        // since I plan to have each command buffer be dedicated to a single state.
        commandPoolCreateInfo.flags = VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT;
        commandPoolCreateInfo.queueFamilyIndex = queueFamily;
        checkVulkan(vkCreateCommandPool(device, &commandPoolCreateInfo, nullptr, &commandPool));
    }

    CommandPoolVulkan::~CommandPoolVulkan() {
        SP_ASSERT(commandPool != VK_NULL_HANDLE);

        auto device = GraphicsVulkan::GetCurrent()->GetLogicalDevice();
        vkDestroyCommandPool(*device, commandPool, nullptr);
    }
}}