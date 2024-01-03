#pragma once

#include "../../helpers/SpoopyHelpersVulkan.h"
#include "components/CommandPoolVulkan.h"

#include <graphics/GPUResource.h>

#include <memory>
#include <vector>

namespace lime { namespace spoopy {
        class CommandBufferVulkan: public GPUResource<VkCommandBuffer> {
            public:
                CommandBufferVulkan(CommandPoolVulkan* pool, bool begin = true, VkCommandBufferLevel bufferLevel = VK_COMMAND_BUFFER_LEVEL_PRIMARY);
                ~CommandBufferVulkan();

                void BeginRecord();
                void EndRecord();
                void BeginRenderPass(const VkRenderPass &renderPass, const VkFramebuffer &frameBuffer,
                uint32_t width, uint32_t height, uint32_t colorAttachmentCount, uint32_t depthAttachment,
                VkSubpassContents contentsFlag);
                void EndRenderPass();

                void BindPipeline(const VkPipeline &renderPipeline);
                void SetBeginFlags(const VkCommandBufferUsageFlags &usage);
                void SetBeginType(const VkStructureType &type);
                // void Submit(const VkSemaphore &waitSemaphore, const VkSemaphore &signalSemaphore, VkFence fence);
                void SubmitIdle(const VkQueue &queue);
                void Free();

                inline uint64_t GetFenceSignaledCounter() const { return _fenceSignaledCounter; }

                bool IsRunning() const { return running; }

                std::vector<VkPipelineStageFlags> waitDstStageMask;

            private:
                void BeginRenderPass(const VkRenderPass &renderPass, const VkFramebuffer &frameBuffer,
                uint32_t width, uint32_t height, VkSubpassContents flags, std::vector<VkClearValue> clearValues);

                VkCommandBuffer &_commandBuffer;

                uint64_t _fenceSignaledCounter;
                VkCommandBufferUsageFlags _usageFlags;
                VkStructureType _sType;

                CommandPoolVulkan* _commandPool;

                bool running = false;
        };
    }}