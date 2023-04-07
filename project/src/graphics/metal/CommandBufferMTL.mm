#include "CommandBufferMTL.h"

/*
 * TODO: Make the methods for Texture and Stencil.
 */
namespace lime {
    CommandBufferMTL::CommandBufferMTL(id<MTLDevice> device): _device(device) {
        _renderTargetWidth = 0;
        _renderTargetHeight = 0;
    }

    MTLPrimitiveType CommandBufferMTL::getMTLPrimitiveType(int primitiveType) {
        MTLPrimitiveType ret = MTLPrimitiveTypeTriangle;

        switch(primitiveType) {
            case 0x0000:
                ret = MTLPrimitiveTypePoint;
                break;
            case 0x0001:
                ret = MTLPrimitiveTypeLine;
                break;
            case 0x0003:
                ret = MTLPrimitiveTypeLineStrip;
                break;
            case 0x0004:
                ret = MTLPrimitiveTypeTriangle;
                break;
            case 0x0005:
                ret = MTLPrimitiveTypeTriangleStrip;
                break;
            default:
                break;
        }

        return ret;
    }

    MTLIndexType CommandBufferMTL::getMTLIndexType(int indexFormat) {
        if(indexFormat == 0x1403) {
            return MTLIndexTypeUInt16;
        }

        return MTLIndexTypeUInt32;
    }

    void CommandBufferMTL::storeCommandQueue(id<MTLCommandQueue> commandQueue) {
        _commandQueue = commandQueue;
    }

    void CommandBufferMTL::storeDrawable(id<CAMetalDrawable> drawable) {
        _drawable = drawable;
    }

    void CommandBufferMTL::beginFrame() {
        #ifndef OBJC_ARC
        pool = [[NSAutoreleasePool alloc] init];
        #endif

        _commandBuffer = [_commandQueue commandBuffer];
        enqueue(_commandBuffer);
        retain(_commandBuffer);
    }

    void CommandBufferMTL::refreshRenderCommandEncoder(MTLRenderPassDescriptor* renderPassDescriptor) {
        if(_renderCommandEncoder != nil && renderPassDescriptor == _prevDescriptor) {
            return;
        }else {
            _prevDescriptor = renderPassDescriptor;
        }

        if(_renderCommandEncoder != nil) {
            endEncoding(_renderCommandEncoder);
            release(_renderCommandEncoder);
            _renderCommandEncoder = nil;
        }

        _renderTargetWidth = (unsigned int)_prevDescriptor.colorAttachments[0].texture.width;
        _renderTargetHeight = (unsigned int)_prevDescriptor.colorAttachments[0].texture.height;
        _renderCommandEncoder = [_commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        retain(_renderCommandEncoder);
    }

    void CommandBufferMTL::setRenderPipeline(SpoopyPipelineState& renderPipeline) {
        [_renderCommandEncoder setRenderPipelineState:renderPipeline];
    }

    void CommandBufferMTL::setViewport(Rectangle* rect) {
        MTLViewport viewport;
        viewport.originX = rect -> x;
        viewport.originY = (int)(_renderTargetHeight - rect -> y - rect -> height);
        viewport.width = rect -> width;
        viewport.height = rect -> height;
        viewport.znear = -1;
        viewport.zfar = 1;

        [_renderCommandEncoder setViewport:viewport];
    }

    void CommandBufferMTL::setScissor(bool isEnabled, Rectangle* rect) {
        MTLScissorRect scissorRect;

        if(isEnabled) {
            rect -> y = (int)(_renderTargetHeight - rect -> y - rect -> height);

            int minX = CLAMP((int)rect -> x, 0, (int)_renderTargetWidth);
            int minY = CLAMP((int)rect -> y, 0, (int)_renderTargetHeight);
            int maxX = CLAMP((int)(rect -> x + rect -> width), 0, (int)_renderTargetWidth);
            int maxY = CLAMP((int)(rect -> y + rect -> height), 0, (int)_renderTargetHeight);

            scissorRect.x = minX;
            scissorRect.y = minY;
            scissorRect.width = maxX - minX;
            scissorRect.height = maxY - minY;

            if(scissorRect.width == 0 || scissorRect.height == 0) {
                scissorRect.width = 0;
                scissorRect.height = 0;
            }
        }else {
            scissorRect.x = 0;
            scissorRect.y = 0;
            scissorRect.width = _renderTargetWidth;
            scissorRect.height = _renderTargetHeight;
        }

        [_renderCommandEncoder setScissorRect:scissorRect];
    }

    void CommandBufferMTL::setCullMode(int cullMode) {
        switch(cullMode) {
            case 0x0404:
                [_renderCommandEncoder setCullMode:MTLCullModeFront];
                break;
            case 0x0405:
                [_renderCommandEncoder setCullMode:MTLCullModeBack];
                break;
            default: // CULL_MODE_NONE
                [_renderCommandEncoder setCullMode:MTLCullModeNone];
                break;
        }
    }

    void CommandBufferMTL::setWinding(int winding) {
        MTLWinding mtlWinding;

        switch(winding) {
            case 0x0900:
                mtlWinding = MTLWindingClockwise;
                break;
            default:
                mtlWinding = MTLWindingCounterClockwise;
                break;
        }

        [_renderCommandEncoder setFrontFacingWinding:mtlWinding];
    }

    void CommandBufferMTL::setVertexBuffer(Buffer* buffer, int offset, int index) {
        [_renderCommandEncoder setVertexBuffer:static_cast<BufferMTL*>(buffer) -> getMTLBuffer() offset:offset atIndex:index];
    }

    void CommandBufferMTL::setIndexBuffer(Buffer* buffer) {
        assert(buffer != nullptr);

        if(!buffer) {
            return;
        }

        _indexBufferMTL = static_cast<BufferMTL*>(buffer) -> getMTLBuffer();
        retain(_indexBufferMTL);
    }

    void CommandBufferMTL::setUniformBuffer(void* bufferData, size_t bufferSize, int bufferIndex) {
        if(bufferData) {
            [_renderCommandEncoder setVertexBytes:bufferData length:bufferSize atIndex:bufferIndex];
        }
    }

    void CommandBufferMTL::drawArrays(int primitiveType, size_t start, size_t count) {
        [_renderCommandEncoder drawPrimitives:getMTLPrimitiveType(primitiveType) vertexStart:start vertexCount:count];
    }

    void CommandBufferMTL::drawElements(int primitiveType, int indexFormat, size_t count, size_t offset) {
        [_renderCommandEncoder drawIndexedPrimitives:getMTLPrimitiveType(primitiveType) indexCount:count indexType:getMTLIndexType(indexFormat) indexBuffer:_indexBufferMTL indexBufferOffset:offset];
    }

    void CommandBufferMTL::endDraw() {
        if(_indexBufferMTL) {
            release(_indexBufferMTL);
            _indexBufferMTL = nil;
        }
    }

    void CommandBufferMTL::endFrame() {
        [_renderCommandEncoder endEncoding];
        [_renderCommandEncoder release];
        _renderCommandEncoder = nil;

        [_commandBuffer presentDrawable:_drawable];
        _drawableTexture = _drawable.texture;

        [_commandBuffer commit];
        [_commandBuffer release];

        _drawable = nil;

        #ifndef OBJC_ARC
        [pool drain];
        #endif
    }

    /*
     * TODO: Make the methods for Texture and Stencil.
     */

    CommandBufferMTL::~CommandBufferMTL() {
        _device = nil;
        _commandQueue = nil;
        _commandBuffer = nil;
        _renderCommandEncoder = nil;
        _indexBufferMTL = nil;
        _prevDescriptor = nil;
        _drawable = nil;
    }
}