#include "GraphicsVulkan.h"
#include "CommandBufferVulkan.h"

#include <spoopy_assert.h>

#include <stdint.h>
#include <vector>

namespace lime { namespace spoopy {
    CommandBufferVulkan::CommandBufferVulkan(CommandPoolVulkan* pool, bool begin, VkCommandBufferLevel bufferLevel)
    : GPUResource(*GraphicsVulkan::GetCurrent()->GetLogicalDevice())
    , _usageFlags(VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT)
    , _sType(VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO)
    , _fenceSignaledCounter(0)
    , _commandPool(pool)
    , _commandBuffer(handle) {
        _commandBuffer = VK_NULL_HANDLE;

        VkCommandBufferAllocateInfo commandBufferAllocateInfo = {};
        commandBufferAllocateInfo.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
        commandBufferAllocateInfo.commandPool = *_commandPool;
        commandBufferAllocateInfo.level = bufferLevel;
        commandBufferAllocateInfo.commandBufferCount = 1;
        checkVulkan(vkAllocateCommandBuffers(device, &commandBufferAllocateInfo, &_commandBuffer));

        if (begin) {
            BeginRecord();
        }
    }

    CommandBufferVulkan::~CommandBufferVulkan() {
        if(_commandBuffer != VK_NULL_HANDLE) Free();
    }

    void CommandBufferVulkan::BeginRecord() {
        if (running) {
            return;
        }

        VkCommandBufferBeginInfo beginInfo = {};
        beginInfo.sType = _sType;
        beginInfo.flags = _usageFlags;
        beginInfo.pNext = nullptr;
        checkVulkan(vkBeginCommandBuffer(_commandBuffer, &beginInfo));
        running = true;
    }

    void CommandBufferVulkan::EndRecord() {
        if (!running) {
            return;
        }

        checkVulkan(vkEndCommandBuffer(_commandBuffer));
        running = false;
    }

    void CommandBufferVulkan::BindPipeline(const VkPipeline &renderPipeline) {
        vkCmdBindPipeline(_commandBuffer, VK_PIPELINE_BIND_POINT_GRAPHICS, renderPipeline);
    }

    void CommandBufferVulkan::SetBeginFlags(const VkCommandBufferUsageFlags &usage) {
        _usageFlags = usage;
    }

    void CommandBufferVulkan::SetBeginType(const VkStructureType &type) {
        _sType = type;
    }

    void CommandBufferVulkan::SubmitIdle(const VkQueue &queue) {
        if (running) {
            EndRecord();
        }

        VkSubmitInfo submitInfo = {};
        submitInfo.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;
        submitInfo.commandBufferCount = 1;
        submitInfo.pCommandBuffers = &_commandBuffer;

        VkFenceCreateInfo fenceCreateInfo = {};
        fenceCreateInfo.sType = VK_STRUCTURE_TYPE_FENCE_CREATE_INFO;

        VkFence fence;
        checkVulkan(vkCreateFence(device, &fenceCreateInfo, nullptr, &fence));
        checkVulkan(vkResetFences(device, 1, &fence));
        checkVulkan(vkQueueSubmit(queue, 1, &submitInfo, fence));
        checkVulkan(vkWaitForFences(device, 1, &fence, VK_TRUE, UINT64_MAX));
        vkDestroyFence(device, fence, nullptr);
    }

    void CommandBufferVulkan::BeginRenderPass(const VkRenderPass &renderPass, const VkFramebuffer &frameBuffer,
    uint32_t width, uint32_t height, uint32_t colorAttachmentCount, uint32_t depthAttachment,
    VkSubpassContents contentsFlag) {
        std::vector<VkClearValue> clearValues(colorAttachmentCount + depthAttachment);

        for(uint32_t i=0; i<colorAttachmentCount; ++i) {
            clearValues[i].color = {0.0f, 0.0f, 0.0f, 1.0f};
        }

        if(depthAttachment == 1) {
            clearValues[colorAttachmentCount].depthStencil = {1.0f, 0};
        }

        BeginRenderPass(renderPass, frameBuffer, width, height, contentsFlag, clearValues);
    }

    void CommandBufferVulkan::BeginRenderPass(const VkRenderPass &renderPass, const VkFramebuffer &frameBuffer,
        uint32_t width, uint32_t height, VkSubpassContents flags, std::vector<VkClearValue> clearValues) {
        VkRect2D renderArea = {};
        renderArea.offset = {0, 0};
        renderArea.extent = {width, height};

        VkRect2D scissor = {};
        scissor.offset = renderArea.offset;
        scissor.extent = renderArea.extent;
        vkCmdSetScissor(_commandBuffer, 0, 1, &scissor);

        VkRenderPassBeginInfo renderPassBeginInfo = {};
        renderPassBeginInfo.sType = VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO;
        renderPassBeginInfo.pNext = nullptr;
        renderPassBeginInfo.renderPass = renderPass;
        renderPassBeginInfo.framebuffer = frameBuffer;
        renderPassBeginInfo.renderArea = renderArea;
        renderPassBeginInfo.pClearValues = clearValues.data();
        renderPassBeginInfo.clearValueCount = static_cast<uint32_t>(clearValues.size());

        vkCmdBeginRenderPass(_commandBuffer, &renderPassBeginInfo, flags);
    }

    void CommandBufferVulkan::EndRenderPass() {
        vkCmdEndRenderPass(_commandBuffer);
    }

    void CommandBufferVulkan::Free() {
        vkFreeCommandBuffers(device, _commandPool->GetHandle(), 1, &_commandBuffer);
        _commandBuffer = VK_NULL_HANDLE;
    }
}}