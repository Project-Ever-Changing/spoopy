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
            virtual void Update();

        private:
            Viewport viewport;
            RenderAreaVulkan renderArea;

            const ContextVulkan& context;

            std::unique_ptr<ImageDepth> depthImage;
            std::unique_ptr<SCFrameBuffers> frameBuffers;

            bool isDirty = false;
    };
}}