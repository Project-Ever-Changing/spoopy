#pragma once

#include "RenderAreaVulkan.h"

#include <graphics/Viewport.h>

#include <memory>
#include <vector>

namespace lime { namespace spoopy {
    class RenderPassVulkan;
    class ContextVulkan;

    class ContextStage {
        public:
            ContextStage(const ContextVulkan &context, const Viewport &viewport);
            ~ContextStage();

            virtual void SetViewport(const Viewport &viewport);
            virtual void UpdateViewport(const VkCommandBuffer &commandBuffer);
            virtual void Update();

            const RenderAreaVulkan &GetRenderArea() const { return renderArea; }
            const Viewport &GetViewport() const { return viewport; }

            bool IsDirty() const { return isDirty; }

        private:
            RenderAreaVulkan renderArea;
            Viewport viewport;

            const ContextVulkan& context;

            bool isDirty;
    };
}}