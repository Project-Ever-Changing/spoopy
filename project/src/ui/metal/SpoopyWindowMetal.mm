#ifdef HX_MACOS
#import <Cocoa/Cocoa.h>
#else
#import <UIKit/UIKit.h>
#endif

#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

#include <ui/SpoopyWindowSurface.h>

#include <SDL_metal.h>

namespace lime {
    class SpoopyWindowMetal: public SpoopyWindowSurface {
        public:
            #ifdef SPOOPY_SDL
            SpoopyWindowMetal(const SDLWindow &m_window);
            #endif

            ~SpoopyWindowMetal();

            virtual void assignMetalDevice(value __layerDevice);
            virtual void setVertexBuffer(value __buffer, int offset, int atIndex);

            virtual void render();
            virtual void clear();

            virtual const SDLWindow& getWindow() const;
        private:
            const SDLWindow &m_window;

            CAMetalLayer* layer;

            id<MTLCommandQueue> commandQueue;
            id<MTLDevice> layerDevice;

            id <MTLRenderCommandEncoder> renderEncoder;
            id <MTLCommandBuffer> buffer;
            id <CAMetalDrawable> surface;

            float rbga[4] = {0.0f, 0.0f, 0.0f, 0.0f};

            #ifndef OBJC_ARC
            NSAutoreleasePool* pool;
            #endif
    };


    #ifdef SPOOPY_SDL
    SpoopyWindowMetal::SpoopyWindowMetal(const SDLWindow &m_window): m_window(m_window) {
        SDL_SetHint(SDL_HINT_RENDER_DRIVER, "Metal");
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

        CAMetalLayer* layer = (__bridge CAMetalLayer*)SDL_RenderGetMetalLayer(m_window.sdlRenderer);
        layer.pixelFormat = MTLPixelFormatBGRA8Unorm;

        commandQueue = [layerDevice newCommandQueue];
    }

    void SpoopyWindowMetal::setVertexBuffer(value __buffer, int offset, int atIndex) {
        if(renderEncoder == nil) {
            return;
        }

        //[renderEncoder ];
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
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(rbga[0], rbga[1], rbga[2], rbga[3]);
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

    SpoopyWindowMetal::~SpoopyWindowMetal() {
        if(pool != nil) {
            clear();
        }


        /*
        * Just to be safe than sorry.
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