#pragma once

#include <helpers/SpoopyHelpers.h>

#include <spoopy.h>
#include <memory>

#include "GraphicsVulkan.h"
#include "../CommandBuffer.h"

#ifdef SPOOPY_VOLK
#include <volk.h>
#endif

class CommandBufferVulkan {
    public:
        CommandBufferVulkan();
        CommandBufferVulkan(bool begin = true, VkCommandPool commandPool);
        ~CommandBufferVulkan();

        void BeginFrame();
        void EndFrame();

        void BindPipeline(SpoopyPipelineState renderPipeline);
        void SetBeginFlags(VkCommandBufferUsageFlags usage);
    private:
        VkDevice _device;

        VkCommandPool _commandPool;
        VkCommandBuffer _commandBuffer;

        VkCommandBufferUsageFlags _usageFlags;

        bool running = false;
};
