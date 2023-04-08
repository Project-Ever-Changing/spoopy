#pragma once

#include <graphics/Buffer.h>
#include <math/Rectangle.h>

#ifdef SPOOPY_METAL
#import "../helpers/metal/SpoopyMetalHelpers.h"
#endif

#include <helpers/SpoopyRenderTypes.h>

namespace lime {
    class CommandBuffer {
        public:
            virtual ~CommandBuffer() {};

            virtual void beginFrame() = 0;
            virtual void endFrame() = 0;
            virtual void setRenderPipeline(SpoopyPipelineState& renderPipeline) = 0;
            virtual void setViewport(Rectangle* rect) = 0;
            virtual void setScissor(bool isEnabled, Rectangle* rect) = 0;
            virtual void setCullMode(int cullMode) = 0;
            virtual void setWinding(int winding) = 0;
            virtual void setLineWidth(float width) = 0;
            virtual void setIndexBuffer(Buffer* buffer) = 0;
            virtual void setVertexBuffer(Buffer* buffer, int offset, int index) = 0;
            virtual void setUniformBuffer(void* bufferData, size_t bufferSize, int bufferIndex) = 0;

            virtual void drawArrays(int primitiveType, size_t start, size_t count) = 0;
            virtual void drawElements(int primitiveType, int indexFormat, size_t count, size_t offset) = 0;
            virtual void endDraw() = 0;
    };
}
