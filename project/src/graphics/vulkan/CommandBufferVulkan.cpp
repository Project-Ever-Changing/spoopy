//
// Created by Diego Fonseca on 5/28/23.
//

#include "CommandBufferVulkan.h"

CommandBufferVulkan::CommandBufferVulkan():
    _device(GraphicsVulkan::GetCurrent()->GetLogicalDevice()),
    _commandPool(VK_NULL_HANDLE)
    _usageFlags(VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT) {

    BeginFrame();
}

CommandBufferVulkan::CommandBufferVulkan(bool begin, VkCommandPool commandPool):
    _device(GraphicsVulkan::GetCurrent()->GetLogicalDevice()),
    _commandPool(commandPool),
    _usageFlags(VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT) {

    if(begin) {
        BeginFrame();
    }
}

CommandBufferVulkan::~CommandBufferVulkan() {
    vkFreeCommandBuffers(*_device, _commandPool, 1, &_commandBuffer);
    vkDestroyCommandPool(*_device, _commandPool, nullptr);
}

void CommandBufferVulkan::BeginFrame() {
    if(running) {
        return;
    }

    VkCommandBufferAllocateInfo allocInfo = {};
    allocInfo.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
    allocInfo.flags = _usageFlags;
    checkVulkan(vkBeginCommandBuffer(_commandBuffer, &allocInfo));
}

void CommandBufferVulkan::EndFrame() {
    if(!running) {
        return;
    }

    checkVulkan(vkEndCommandBuffer(_commandBuffer));
    running = false;
}

void CommandBufferVulkan::BindPipeline(SpoopyPipelineState renderPipeline) {
    vkCmdBindPipeline(_commandBuffer, VK_PIPELINE_BIND_POINT_GRAPHICS, renderPipeline);
}

void CommandBufferVulkan::SetBeginFlags(VkCommandBufferUsageFlags usage) {
    _usageFlags = usage;
}