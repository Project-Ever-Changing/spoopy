#include "SpoopyWindowRendererMTL.h"

namespace lime {
    #ifdef SPOOPY_SDL
    SpoopyWindowRendererMTL::SpoopyWindowRendererMTL(const SDLWindow &m_window): m_window(m_window) {
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
    #ifdef SPOOPY_SDL
    void SpoopyWindowRendererMTL::assignMetalInstructions() {
        if(_device != nil) { // Just in case.
            release(_device);
        }

        _device = MTLCreateSystemDefaultDevice();

        if(_device != nil) {
            SPOOPY_LOG_SUCCESS("Metal device created successfully!");
        }else {
            SPOOPY_LOG_ERROR("This device does not support Metal!");
        }

	    CAMetalLayer* layer = (CAMetalLayer*)SDL_Metal_GetLayer(m_window.context);

        _commandBuffer = new CommandBufferMTL(_device);
        _commandBuffer -> storeCommandQueue([_device newCommandQueue]);

        if(layer == nil) {
            SPOOPY_LOG_ERROR("Unable to create CAMetalLayer from SDL!");
        }else {
            SPOOPY_LOG_SUCCESS("CAMetalLayer created successfully from SDL!");
        }

        layer.device = _device;
        retain(_device);
    }
    #endif

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

        #ifdef SPOOPY_SDL

        int width, height;

        SDL_GetWindowSize (m_window.sdlWindow, &width, &height);
        layer.pixelFormat = MTLPixelFormatBGRA8Unorm;
        layer.drawableSize = CGSizeMake(width, height);
        id<CAMetalDrawable> drawable = [layer nextDrawable];

        if(drawable == nil) {
            SPOOPY_LOG_ERROR("Unable to find CAMetalDrawable! Drawable size (" + std::to_string(width) + ", " + std::to_string(height) + ").");
            return;
        }

        _commandBuffer -> storeDrawable(drawable);
        _commandBuffer -> beginFrame();

        #endif
    }

    void SpoopyWindowRendererMTL::beginRenderPass() {
        _commandBuffer -> beginRenderPass(renderPassDescriptor);
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
        }else {
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

        release(layer);
        release(_device);
    }

    #ifdef SPOOPY_SDL    
    SpoopyWindowRenderer* createWindowRenderer(const SDLWindow &m_window) {
        return new SpoopyWindowRendererMTL(m_window);
    }
    #endif
}