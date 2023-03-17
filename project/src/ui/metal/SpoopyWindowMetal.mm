#import "../../helpers/SpoopyMetalHelpers.mm"

#include <ui/SpoopyWindowSurface.h>

#include <SDL_metal.h>

namespace lime {

    enum SPOOPY_CULL_MODE {
        CULL_MODE_NONE = 0x00000000,
        CULL_MODE_FRONT = 0x00000001,
        CULL_MODE_BACK = 0x00000002
    };


    class SpoopyWindowMetal: public SpoopyWindowSurface {
        public:
            #ifdef SPOOPY_SDL
            SpoopyWindowMetal(const SDLWindow &m_window);
            #endif

            ~SpoopyWindowMetal();

            virtual void assignMetalDevice(value __layerDevice);
            virtual void setVertexBuffer(value __buffer, int __offset, int __atIndex);

            virtual void render();
            virtual void clear();

            virtual void cullFace(int cullMode);

            virtual const SDLWindow& getWindow() const;
        private:
            const SDLWindow &m_window;

            CAMetalLayer* layer;

            id<MTLCommandQueue> commandQueue;
            id<MTLDevice> layerDevice;

            id <MTLRenderCommandEncoder> renderEncoder;
            id <MTLCommandBuffer> buffer;
            id <CAMetalDrawable> surface;

            float rgba[4];

            #ifndef OBJC_ARC
            NSAutoreleasePool* pool;
            #endif
    };


    #ifdef SPOOPY_SDL
    SpoopyWindowMetal::SpoopyWindowMetal(const SDLWindow &m_window): m_window(m_window) {
        SDL_SetHint(SDL_HINT_RENDER_DRIVER, "Metal");

        rgba[0] = 0.0f;
        rgba[1] = 0.0f;
        rgba[2] = 0.0f;
        rgba[3] = 1.0f;
    }

    const SDLWindow& SpoopyWindowMetal::getWindow() const {
        return m_window;
    }
    #endif

    void SpoopyWindowMetal::assignMetalDevice(value __layerDevice) {
        layerDevice = (id<MTLDevice>)val_data(__layerDevice);

        if (!layerDevice) {
            printf("Failed to create Metal device!");
            return;
        }

        layer = (__bridge CAMetalLayer*)SDL_RenderGetMetalLayer(m_window.sdlRenderer);
        layer.pixelFormat = SpoopyMetalHelper::convertSDLtoMetal(SDL_GetWindowPixelFormat(m_window.sdlWindow));

        commandQueue = [layerDevice newCommandQueue];
    }

    void SpoopyWindowMetal::setVertexBuffer(value __buffer, int __offset, int __atIndex) {
        if(renderEncoder == nil) {
            return;
        }

        id<MTLBuffer> bufferOBJ = (id<MTLBuffer>)val_data(__buffer);
        [renderEncoder setVertexBuffer:bufferOBJ offset:__offset atIndex:__atIndex];
    }

    void SpoopyWindowMetal::render() {
        #ifndef OBJC_ARC
        pool = [[NSAutoreleasePool alloc] init];
        #endif

        int width, height;

        SDL_GetRendererOutputSize(getWindow().sdlRenderer, &width, &height);
        layer.drawableSize = CGSizeMake(width, height);

        surface = [layer nextDrawable];

        MTLRenderPassDescriptor* renderPassDescriptor = [MTLRenderPassDescriptor new];
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(rgba[0], rgba[1], rgba[2], rgba[3]);
        renderPassDescriptor.colorAttachments[0].texture = surface.texture;
        renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
        renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;

        buffer = [commandQueue commandBuffer];
        renderEncoder = [buffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    }

    void SpoopyWindowMetal::clear() {
        [renderEncoder endEncoding];
        [buffer presentDrawable:surface];
        [buffer commit];

        #ifndef OBJC_ARC
        [pool drain];
        #endif
    }

    void SpoopyWindowMetal::cullFace(int cullMode) {
        if(renderEncoder == nil) {
            return;
        }

        switch(cullMode) {
            case CULL_MODE_FRONT:
                [renderEncoder setCullMode:MTLCullModeFront];
                break;
            case CULL_MODE_BACK:
                [renderEncoder setCullMode:MTLCullModeBack];
                break;
            default: // CULL_MODE_NONE
                [renderEncoder setCullMode:MTLCullModeNone];
                break;
        }
    }

    SpoopyWindowMetal::~SpoopyWindowMetal() {
        if(pool != nil) {
            clear();
        }


        /*
        * Just to be safer than sorry.
        * What if `OBJC_ARC` is defined.
        */

        if(renderEncoder != nil) {
            [renderEncoder release];
            renderEncoder = nil;
        }

        if(buffer != nil) {
            [buffer release];
            buffer = nil;
        }

        if(surface != nil) {
            [surface release];
            surface = nil;
        }

        if(commandQueue != nil) {
            [commandQueue release];
            commandQueue = nil;
        }

        if(layerDevice != nil) {
            [layerDevice release];
            layerDevice = nil;
        }

        if(layer != nil) {
            [layer release];
            layer = nil;
        }
    }

    #ifdef SPOOPY_SDL    
    SpoopyWindowSurface* createWindowSurface(const SDLWindow &m_window) {
        return new SpoopyWindowMetal(m_window);
    }
    #endif
}