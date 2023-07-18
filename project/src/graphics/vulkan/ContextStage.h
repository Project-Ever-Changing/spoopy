#pragma once

#include "RenderAreaVulkan.h"

#include <graphics/Viewport.h>

#include <memory>
#include <vector>

namespace lime { namespace spoopy {
    class ImageDepth;
    class RenderPassVulkan;
    class SCFrameBuffers;
    class ContextVulkan;

    class ContextStage {
        public:
            ContextStage(const ContextVulkan &context, const Viewport &viewport);
            ~ContextStage();

            virtual void Build(const RenderPassVulkan &renderPass);
            virtual void SetViewport(const Viewport &viewport);
            virtual void UpdateViewport(const VkCommandBuffer &commandBuffer);
            virtual void Update();

            const VkFramebuffer &GetActiveFramebuffer(uint32_t activeSwapchainImage) const;
            const RenderAreaVulkan &GetRenderArea() const { return renderArea; }
            const Viewport &GetViewport() const { return viewport; }

            bool IsDirty() const { return isDirty; }

        private:
            RenderAreaVulkan renderArea;
            Viewport viewport;

            const ContextVulkan& context;

            std::unique_ptr<ImageDepth> depthImage;
            std::unique_ptr<SCFrameBuffers> frameBuffers;

            bool isDirty;
    };
}}