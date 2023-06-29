#pragma once

#include "../GraphicsVulkan.h"
#include "../FrameBufferVulkan.h"

#include <math/Vector2T.h>

#include <vector>
#include <memory>

/*
 * This is one of many storage classes for the FrameBufferVulkan class.
 * It is mainly used to create frame buffers using the swapchain.
 */

namespace lime { namespace spoopy {
    class SwapchainVulkan;
    class RenderPassVulkan;
    class ImageDepth;

    class SCFrameBuffers {
        public:
            SCFrameBuffers(const LogicalDevice &device, const SwapchainVulkan &swapchain, const RenderPassVulkan &renderPass,
                const ImageDepth* depthImage, const Vector2T_u32 &extent);
            ~SCFrameBuffers();

            const FrameBufferVulkan &GetFrameBuffer(uint32_t index) const { return *frameBuffers.at(index).get(); }
            const std::size_t GetFrameBufferCount() const { return frameBuffers.size(); }

        private:
            std::vector<std::unique_ptr<FrameBufferVulkan>> frameBuffers;
    };
}}