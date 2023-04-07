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
    void SpoopyWindowRendererMTL::assignMetalDevice(value __layerDevice) {
        id<MTLDevice> _device = (id<MTLDevice>)val_data(__layerDevice);

        if (!_device) {
            printf("Failed to create Metal device!");
            return;
        }

        layer = (__bridge CAMetalLayer*)SDL_RenderGetMetalLayer(m_window.sdlRenderer);
        layer.pixelFormat = SpoopyMetalHelpers::convertSDLtoMetal(SDL_GetWindowPixelFormat(m_window.sdlWindow));

        commandBuffer = new CommandBufferMTL(_device);
        commandBuffer -> storeCommandQueue([_device newCommandQueue]);
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

    void SpoopyWindowRendererMTL::setViewport(Rectangle* rect) {
        commandBuffer -> setViewport(rect);
    }

    void SpoopyWindowRendererMTL::setScissorMode(bool isEnabled, Rectangle* rect) {
        commandBuffer -> setScissor(isEnabled, rect);
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

    CAMetalLayer* SpoopyWindowRendererMTL::getMetalLayer() const {
        return layer;
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