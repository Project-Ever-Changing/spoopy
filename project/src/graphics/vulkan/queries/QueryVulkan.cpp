#include "../../helpers/SpoopyHelpersVulkan.h"
#include "QueryVulkan.h"

#include <core/Log.h>

namespace lime { namespace spoopy {
    QueryPoolVulkan::QueryPoolVulkan(LogicalDevice &device, CommandBufferVulkan* cmdBuffer, uint32_t capacity, VkQueryType type)
    : GPUResource(device)
    , handle(VK_NULL_HANDLE)
    , resetEvent(VK_NULL_HANDLE) {
        VkResult result = VK_SUCCESS;

        VkQueryPoolCreateInfo createInfo;
        createInfo.sType = VK_STRUCTURE_TYPE_QUERY_POOL_CREATE_INFO;
        createInfo.type = type;
        createInfo.queryCount = capacity;

        result = vkCreateQueryPool(device, &createInfo, nullptr, &handle);
        queryData.resize(capacity);

        if(result != VK_SUCCESS) {
            switch(type) {
                case VK_QUERY_TYPE_OCCLUSION:
                    SPOOPY_LOG_ERROR("Failed to create occlusion query pool: " + checkVulkan(result));
                    break;
                case VK_QUERY_TYPE_TIMESTAMP:
                    SPOOPY_LOG_ERROR("Failed to create timestamp query pool: " + checkVulkan(result));
                    break;
            }

            return;
        }

        const VkCommandBuffer commandBuffer = cmdBuffer->GetHandle();
        vkCmdResetQueryPool(commandBuffer, handle, 0, capacity);

        VkEventCreateInfo eventCreateInfo;
        eventCreateInfo.sType = VK_STRUCTURE_TYPE_EVENT_CREATE_INFO;
        checkVulkan(vkCreateEvent(device, &eventCreateInfo, nullptr, &resetEvent));
    }

    QueryPoolVulkan::~QueryPoolVulkan() {
        vkDestroyEvent(device, resetEvent, nullptr);
        vkDestroyQueryPool(device, handle, nullptr);

        resetEvent = VK_NULL_HANDLE;
        handle = VK_NULL_HANDLE;
    }

    void QueryPoolVulkan::Reset(CommandBufferVulkan* cmdBuffer, uint32_t start, uint32_t end) {
        vkCmdResetQueryPool(cmdBuffer->GetHandle(), handle, start, end);
    }

    bool QueryPoolVulkan::GetResults(uint32_t index, uint64_4 &count) {
        VkResult result = vkGetEventStatus(device, resetEvent);

        if (result == VK_EVENT_SET) {
            result = vkGetQueryPoolResults(
                device,
                handle,
                index,
                1, // Number of queries to retrieve
                queryData.size() * sizeof(uint64_t),
                queryData.data(),
                sizeof(uint64_t),
                VK_QUERY_RESULT_64_BIT
            );

            if (result == VK_SUCCESS) {
                count = queryData[index];
                return true;
            } else {
                checkVulkan(result);
                return false;
            }
        }

        return result == VK_NOT_READY;
    }
}}