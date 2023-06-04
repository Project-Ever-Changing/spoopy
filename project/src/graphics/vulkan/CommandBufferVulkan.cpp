#include "GraphicsVulkan.h"
#include "CommandBufferVulkan.h"

namespace lime {
    CommandBufferVulkan::CommandBufferVulkan(bool begin, VkCommandPool commandPool) :
            _device(*GraphicsVulkan::GetCurrent()->GetLogicalDevice()),
            _commandPool(commandPool),
            _usageFlags(VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT) {

        if (begin) {
            BeginFrame();
        }
    }

    CommandBufferVulkan::~CommandBufferVulkan() {
        vkFreeCommandBuffers(_device, _commandPool, 1, &_commandBuffer);
        vkDestroyCommandPool(_device, _commandPool, nullptr);
    }

    void CommandBufferVulkan::BeginFrame() {
        if (running) {
            return;
        }

        VkCommandBufferBeginInfo beginInfo = {};
        beginInfo.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
        beginInfo.flags = _usageFlags;
        checkVulkan(vkBeginCommandBuffer(_commandBuffer, &beginInfo));
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
}