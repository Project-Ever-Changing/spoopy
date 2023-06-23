#pragma once

#include "../../helpers/SpoopyHelpersVulkan.h"
#include "CommandPoolVulkan.h"

#include <memory>

namespace lime { namespace spoopy {
    class CommandBufferVulkan {
        public:
            CommandBufferVulkan(bool begin = true, VkQueueFlagBits queueType = VK_QUEUE_GRAPHICS_BIT, VkCommandBufferLevel bufferLevel = VK_COMMAND_BUFFER_LEVEL_PRIMARY);
            ~CommandBufferVulkan();

            void BeginRecord();
            void EndRecord();
            void BeginRenderPass(VkRenderPass renderPass, VkFramebuffer frameBuffer,
                uint32_t width, uint32_t height, uint32_t colorAttachmentCount, int depthAttachment,
                VkSubpassContents contentsFlag);
            void EndRenderPass();

            void BindPipeline(const VkPipeline renderPipeline);
            void SetBeginFlags(const VkCommandBufferUsageFlags usage);
            void SetBeginType(const VkStructureType type);
            void SubmitIdle(const VkQueue queue);

            operator const VkCommandBuffer &() const { return _commandBuffer; }

            VkQueueFlagBits GetQueueType() const { return _queueType; }

        private:
            void BeginRenderPass(VkRenderPass renderPass, VkFramebuffer frameBuffer,
                uint32_t width, uint32_t height, VkSubpassContents flags, std::vector<VkClearValue> clearValues);

            std::shared_ptr<CommandPoolVulkan> _commandPool;

            VkDevice _device = VK_NULL_HANDLE;
            VkCommandBuffer _commandBuffer = VK_NULL_HANDLE;
            VkCommandBufferUsageFlags _usageFlags;
            VkStructureType _sType;
            VkQueueFlagBits _queueType;

            bool running = false;
    };
}}
