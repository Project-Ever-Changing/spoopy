#pragma once

#import "../../helpers/metal/SpoopyMetalHelpers.h"

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
            virtual void useProgram(value __pipeline);

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
}
