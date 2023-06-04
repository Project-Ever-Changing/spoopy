#pragma once

#include "CommandPoolVulkan.h"

#include <memory>

namespace lime {
    class CommandBufferVulkan {
        public:
            CommandBufferVulkan(bool begin = true, const VkCommandPool commandPool = VK_NULL_HANDLE);
            ~CommandBufferVulkan();

            void BeginFrame();
            void EndFrame();

            void BindPipeline(const SpoopyPipelineState renderPipeline);
            void SetBeginFlags(const VkCommandBufferUsageFlags usage);

        private:
            VkDevice _device;
            VkCommandPool _commandPool;
            VkCommandBuffer _commandBuffer;
            VkCommandBufferUsageFlags _usageFlags;

            bool running = false;
    };
}
