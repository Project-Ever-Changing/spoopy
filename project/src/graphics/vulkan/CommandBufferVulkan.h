#pragma once

#include <helpers/SpoopyHelpers.h>

#include <spoopy.h>
#include <memory>

#include "GraphicsVulkan.h"
#include "../CommandBuffer.h"

#ifdef SPOOPY_VOLK
#include <volk.h>
#endif

namespace lime {
    class CommandBufferVulkan : public CommandBuffer {
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
