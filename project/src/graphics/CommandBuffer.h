#pragma once

#include <graphics/Buffer.h>
#include <graphics/RenderPassDescriptor.h>
#include <math/Rectangle.h>

#include <spoopy.h>

namespace lime {
    class CommandBuffer {
        public:
            virtual ~CommandBuffer() {};

            virtual void BeginFrame() = 0;
            virtual void EndFrame() = 0;

            virtual void BindPipeline(SpoopyPipelineState renderPipeline) = 0;


            // DEPRECATED

            // virtual void SetViewport(Rectangle* rect) = 0;
            // virtual void SetScissor(bool isEnabled, Rectangle* rect) = 0;
            // virtual void SetCullMode(int cullMode) = 0;
            // virtual void SetWinding(int winding) = 0;
    };
}
