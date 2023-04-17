#include "SpoopyWindowRendererMTL.h"

namespace lime {
    #ifdef SPOOPY_SDL
    SpoopyWindowRendererMTL::SpoopyWindowRendererMTL(const SDLWindow &m_window): m_window(m_window) {
        SDL_SetHint(SDL_HINT_RENDER_DRIVER, "Metal");

        _viewport = new Rectangle(0.0, 0.0, 0.0, 0.0);
        _scissor = new Rectangle(0.0, 0.0, 0.0, 0.0);

        _enabledScissor = false;
        _renderTargetFlag = COLOR;
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

        _commandBuffer = new CommandBufferMTL(layer.device);
        _commandBuffer -> storeCommandQueue([layer.device newCommandQueue]);
    }

    void SpoopyWindowRendererMTL::updateMetalDescriptor() {
        if (_surface == nil || _surface.texture == nil) {
            printf("%s", "Surface or texture is not valid.\n");
            return;
        }
    }

    void SpoopyWindowRendererMTL::setVertexBuffer(value __buffer, int __offset, int __atIndex) {
        Buffer* bufferOBJ = (Buffer*)val_data(__buffer);
        _commandBuffer -> setVertexBuffer(bufferOBJ, __offset, __atIndex);
    }

    void SpoopyWindowRendererMTL::setIndexBuffer(value __buffer) {
        Buffer* bufferOBJ = (Buffer*)val_data(__buffer);
        _commandBuffer -> setIndexBuffer(bufferOBJ);
    }

    void SpoopyWindowRendererMTL::setViewport(Rectangle* rect) {
        if(_viewport != nullptr) {
            delete _viewport;
        }

        _viewport = rect;
    }

    void SpoopyWindowRendererMTL::setScissorMode(bool isEnabled, Rectangle* rect) {
        if(_scissor != nullptr) {
            delete _scissor;
        }

        _scissor = rect;
        _enabledScissor = isEnabled;
    }

    void SpoopyWindowRendererMTL::cullFace(int cullMode) {
        _cullMode = cullMode;
    }

    void SpoopyWindowRendererMTL::setWinding(int winding) {
        _winding = winding;
    }

    void SpoopyWindowRendererMTL::setLineWidth(float width) {
        _commandBuffer -> setLineWidth(width);
    }

    void SpoopyWindowRendererMTL::useProgram(value __pipeline) {
        SpoopyPipelineState pipelineState = (SpoopyPipelineState)val_data(__pipeline);
        _commandBuffer -> setRenderPipeline(pipelineState);
    }

    void SpoopyWindowRendererMTL::render() {
        int width, height;

        SDL_GetRendererOutputSize(getWindow().sdlRenderer, &width, &height);
        layer.drawableSize = CGSizeMake(width, height);

        _surface = [layer nextDrawable];
        _commandBuffer -> storeDrawable(_surface);
        _commandBuffer -> beginFrame();
    }

    void SpoopyWindowRendererMTL::beginRenderPass() {
        //_commandBuffer -> beginRenderPass(_mtlDescriptor);
        _commandBuffer -> setViewport(_viewport);
        _commandBuffer -> setCullMode(_cullMode);
        _commandBuffer -> setWinding(_winding);
        _commandBuffer -> setScissor(_enabledScissor, _scissor);
    }

    void SpoopyWindowRendererMTL::clear() {
        _commandBuffer -> endFrame();
    }

    void SpoopyWindowRendererMTL::drawArrays(int primitiveType, size_t start, size_t count) {
        _commandBuffer -> drawArrays(primitiveType, start, count);
    }

    void SpoopyWindowRendererMTL::drawElements(int primitiveType, int indexFormat, size_t count, size_t offset) {
        _commandBuffer -> drawElements(primitiveType, indexFormat, count, offset);
    }

    void SpoopyWindowRendererMTL::setRenderTarget(RenderTargetFlag flags, Texture2D* colorAttachment, Texture2D* depthAttachment, Texture2D* stencilAttachment) {
        _renderTargetFlag = flags;

        if (flags & COLOR) {
            renderPassDescriptor.needColorAttachment = true;

            if(colorAttachment != nullptr) {
                renderPassDescriptor.colorAttachment[0] = static_cast<Texture2DMTL*>(colorAttachment);
            }else {
                renderPassDescriptor.colorAttachment[0] = nullptr;
            }

            _colorAttachment = static_cast<Texture2DMTL*>(colorAttachment);
        }else {
            _colorAttachment = nullptr;
            renderPassDescriptor.needColorAttachment = false;
            renderPassDescriptor.colorAttachment[0] = nullptr;
        }
    }

    bool SpoopyWindowRendererMTL::findCommandBuffer() const {
        if(_commandBuffer == NULL) {
            printf("%s", "Error: Command buffer object not found.\n");
            return false;
        }

        if(_commandBuffer -> findCommandBuffer()) {
            printf("%s", "Error: Command buffer not found.\n");
            return false;
        }

        return true;
    }

    SpoopyWindowRendererMTL::~SpoopyWindowRendererMTL() {
        if(_viewport != nullptr) {
            delete _viewport;
        }

        if(_scissor != nullptr) {
            delete _scissor;
        }

        if(_commandBuffer != nullptr) {
            delete _commandBuffer;
        }

        release(_surface);
        release(layer);
    }

    #ifdef SPOOPY_SDL    
    SpoopyWindowRenderer* createWindowRenderer(const SDLWindow &m_window) {
        return new SpoopyWindowRendererMTL(m_window);
    }
    #endif
}