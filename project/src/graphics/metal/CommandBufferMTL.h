#pragma once

#include "texture/Texture2DMTL.h"
#include "../CommandBuffer.h"
#include "BufferMTL.h"

#include <core/Log.h>

#import "../../helpers/metal/SpoopyMetalHelpers.h"

namespace lime {
    class CommandBufferMTL: public CommandBuffer {
        public:
            CommandBufferMTL(id<MTLDevice> device);
            ~CommandBufferMTL();

            virtual void beginFrame();
            virtual void endFrame();

            virtual void setRenderPipeline(SpoopyPipelineState& renderPipeline);
            virtual void setViewport(Rectangle* rect);
            virtual void setScissor(bool isEnabled, Rectangle* rect);
            virtual void setCullMode(int cullMode);
            virtual void setWinding(int winding);
            virtual void setLineWidth(float width);
            virtual void setVertexBuffer(Buffer* buffer, int offset, int index);
            virtual void setIndexBuffer(Buffer* buffer);
            virtual void setUniformBuffer(void* bufferData, size_t bufferSize, int bufferIndex);

            virtual void drawArrays(int primitiveType, size_t start, size_t count);
            virtual void drawElements(int primitiveType, int indexFormat, size_t count, size_t offset);
            virtual void endDraw();

            virtual void storeDrawable(id<CAMetalDrawable> drawable);
            virtual void storeCommandQueue(id<MTLCommandQueue> commandQueue);

            virtual bool findCommandBuffer() const;

            virtual void beginRenderPass(RenderPassDescriptor<Texture2DMTL>& renderPassDescriptor);

            virtual id<MTLRenderCommandEncoder> getRenderCommandEncoder(RenderPassDescriptor<Texture2DMTL>& renderPassDescriptor);
        private:
            MTLPrimitiveType getMTLPrimitiveType(int primitiveType);
            MTLIndexType getMTLIndexType(int indexFormat);

            #ifndef OBJC_ARC
            NSAutoreleasePool* pool;
            #endif

            id<MTLDevice> _device;
            id<MTLCommandQueue> _commandQueue;
            id<MTLCommandBuffer> _commandBuffer;
            id<MTLRenderCommandEncoder> _renderCommandEncoder;
            id<CAMetalDrawable> _drawable;
            id<MTLBuffer> _indexBufferMTL;
            id<MTLTexture> _drawableTexture;

            unsigned int _renderTargetWidth;
            unsigned int _renderTargetHeight;

            RenderPassDescriptor<Texture2DMTL> _prevDescriptor;
    };
}