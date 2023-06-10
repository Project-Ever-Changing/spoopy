#include "GraphicsVulkan.h"
#include "CommandBufferVulkan.h"

#include <stdint.h>

namespace lime { namespace spoopy {
    CommandBufferVulkan::CommandBufferVulkan(bool begin, VkQueueFlagBits queueType, VkCommandBufferLevel bufferLevel):
        _device(*GraphicsVulkan::GetCurrent()->GetLogicalDevice()),
        _queueType(queueType),
        _usageFlags(VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT) {

        VkCommandBufferAllocateInfo commandBufferAllocateInfo = {};
        commandBufferAllocateInfo.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
        commandBufferAllocateInfo.commandPool = *_commandPool;
        commandBufferAllocateInfo.level = bufferLevel;
        commandBufferAllocateInfo.commandBufferCount = 1;
        checkVulkan(vkAllocateCommandBuffers(_device, &commandBufferAllocateInfo, &_commandBuffer));

        if (begin) {
            BeginFrame();
        }
    }

    CommandBufferVulkan::~CommandBufferVulkan() {
        vkFreeCommandBuffers(_device, _commandPool->GetCommandPool(), 1, &_commandBuffer);
    }

    void CommandBufferVulkan::BeginFrame() {
        if (running) {
            return;
        }

        VkCommandBufferBeginInfo beginInfo = {};
        beginInfo.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
        beginInfo.flags = _usageFlags;
        checkVulkan(vkBeginCommandBuffer(_commandBuffer, &beginInfo));
        running = true;
    }

    void CommandBufferVulkan::EndFrame() {
        if (!running) {
            return;
        }

        checkVulkan(vkEndCommandBuffer(_commandBuffer));
        running = false;
    }

    void CommandBufferVulkan::BindPipeline(const SpoopyPipelineState renderPipeline) {
        vkCmdBindPipeline(_commandBuffer, VK_PIPELINE_BIND_POINT_GRAPHICS, renderPipeline);
    }

    void CommandBufferVulkan::SetBeginFlags(const VkCommandBufferUsageFlags usage) {
        _usageFlags = usage;
    }

    void CommandBufferVulkan::SubmitIdle(const VkQueue queue) {
        if (running) {
            EndFrame();
        }

        VkSubmitInfo submitInfo = {};
        submitInfo.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;
        submitInfo.commandBufferCount = 1;
        submitInfo.pCommandBuffers = &_commandBuffer;

        VkFenceCreateInfo fenceCreateInfo = {};
        fenceCreateInfo.sType = VK_STRUCTURE_TYPE_FENCE_CREATE_INFO;

        VkFence fence;
        checkVulkan(vkCreateFence(_device, &fenceCreateInfo, nullptr, &fence));
        checkVulkan(vkResetFences(_device, 1, &fence));
        checkVulkan(vkQueueSubmit(queue, 1, &submitInfo, fence));
        checkVulkan(vkWaitForFences(_device, 1, &fence, VK_TRUE, UINT64_MAX));
        vkDestroyFence(_device, fence, nullptr);
    }
}}