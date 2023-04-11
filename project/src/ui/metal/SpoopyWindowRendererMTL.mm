#include "SpoopyWindowRendererMTL.h"

namespace lime {
    #ifdef SPOOPY_SDL
    SpoopyWindowRendererMTL::SpoopyWindowRendererMTL(const SDLWindow &m_window): m_window(m_window) {
        SDL_SetHint(SDL_HINT_RENDER_DRIVER, "Metal");

        rgba[0] = 0.0f;
        rgba[1] = 0.0f;
        rgba[2] = 0.0f;
        rgba[3] = 1.0f;
    }

    const SDLWindow& SpoopyWindowRendererMTL::getWindow() const {
        return m_window;
    }
    #endif

    /*
     * The `init` method.
     */
    void SpoopyWindowRendererMTL::assignMetalDevice() {
        layer = (__bridge CAMetalLayer*)SDL_RenderGetMetalLayer(m_window.sdlRenderer);
        layer.pixelFormat = SpoopyMetalHelpers::convertSDLtoMetal(SDL_GetWindowPixelFormat(m_window.sdlWindow));

        if(layer.device == nil) {
            layer.device = MTLCreateSystemDefaultDevice();
        }

        commandBuffer = new CommandBufferMTL(layer.device);
        commandBuffer -> storeCommandQueue([layer.device newCommandQueue]);
    }

    void SpoopyWindowRendererMTL::updateMetalDescriptor() {
        if(renderPassDescriptor) {
            release(renderPassDescriptor);
        }

        MTLRenderPassDescriptor* renderPassDescriptor = [MTLRenderPassDescriptor new];
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(rgba[0], rgba[1], rgba[2], rgba[3]);
        renderPassDescriptor.colorAttachments[0].texture = _surface.texture;
        renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
        renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
    }

    void SpoopyWindowRendererMTL::setVertexBuffer(value __buffer, int __offset, int __atIndex) {
        Buffer* bufferOBJ = (Buffer*)val_data(__buffer);
        commandBuffer -> setVertexBuffer(bufferOBJ, __offset, __atIndex);
    }

    void SpoopyWindowRendererMTL::setIndexBuffer(value __buffer) {
        Buffer* bufferOBJ = (Buffer*)val_data(__buffer);
        commandBuffer -> setIndexBuffer(bufferOBJ);
    }

    void SpoopyWindowRendererMTL::setViewport(Rectangle* rect) {
        commandBuffer -> setViewport(rect);
    }

    void SpoopyWindowRendererMTL::setScissorMode(bool isEnabled, Rectangle* rect) {
        commandBuffer -> setScissor(isEnabled, rect);
    }

    void SpoopyWindowRendererMTL::setLineWidth(float width) {
        commandBuffer -> setLineWidth(width);
    }

    void SpoopyWindowRendererMTL::useProgram(value __pipeline) {
        SpoopyPipelineState pipelineState = (SpoopyPipelineState)val_data(__pipeline);
        commandBuffer -> setRenderPipeline(pipelineState);
    }

    void SpoopyWindowRendererMTL::render() {
        int width, height;

        commandBuffer -> beginFrame();

        SDL_GetRendererOutputSize(getWindow().sdlRenderer, &width, &height);
        layer.drawableSize = CGSizeMake(width, height);

        _surface = [layer nextDrawable];
        commandBuffer -> storeDrawable(_surface);
    }

    void SpoopyWindowRendererMTL::beginRenderPass() {
        commandBuffer -> refreshRenderCommandEncoder(renderPassDescriptor);
    }

    void SpoopyWindowRendererMTL::clear() {
        commandBuffer -> endFrame();
    }

    void SpoopyWindowRendererMTL::cullFace(int cullMode) {
        commandBuffer -> setCullMode(cullMode);
    }

    void SpoopyWindowRendererMTL::setWinding(int winding) {
        commandBuffer -> setWinding(winding);
    }

    void SpoopyWindowRendererMTL::drawArrays(int primitiveType, size_t start, size_t count) {
        commandBuffer -> drawArrays(primitiveType, start, count);
    }

    void SpoopyWindowRendererMTL::drawElements(int primitiveType, int indexFormat, size_t count, size_t offset) {
        commandBuffer -> drawElements(primitiveType, indexFormat, count, offset);
    }

    bool SpoopyWindowRendererMTL::findCommandBuffer() const {
        if(commandBuffer != NULL) {
            printf("%s", "Error: Command buffer object not found.\n");
            return false;
        }

        if(commandBuffer -> findCommandBuffer()) {
            printf("%s", "Error: Command buffer not found.\n");
            return false;
        }

        return true;
    }

    SpoopyWindowRendererMTL::~SpoopyWindowRendererMTL() {
        if(commandBuffer != nullptr) {
            delete commandBuffer;
        }

        release(renderPassDescriptor);
        release(_surface);
        release(layer);
    }

    #ifdef SPOOPY_SDL    
    SpoopyWindowRenderer* createWindowRenderer(const SDLWindow &m_window) {
        return new SpoopyWindowRendererMTL(m_window);
    }
    #endif
}