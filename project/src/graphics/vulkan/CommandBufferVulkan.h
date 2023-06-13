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

            void BindPipeline(const SpoopyPipelineState renderPipeline);
            void SetBeginFlags(const VkCommandBufferUsageFlags usage);
            void SetBeginType(const VkStructureType type);

            void SubmitIdle(const VkQueue queue);

            operator const VkCommandBuffer &() const { return _commandBuffer; }

            VkQueueFlagBits GetQueueType() const { return _queueType; }

        private:
            std::shared_ptr<CommandPoolVulkan> _commandPool;

            VkDevice _device = VK_NULL_HANDLE;
            VkCommandBuffer _commandBuffer = VK_NULL_HANDLE;
            VkCommandBufferUsageFlags _usageFlags;
            VkStructureType _sType;
            VkQueueFlagBits _queueType;

            bool running = false;
    };
}}
