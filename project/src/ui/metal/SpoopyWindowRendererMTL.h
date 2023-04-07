#pragma once

#import "../../helpers/metal/SpoopyMetalHelpers.h"
#import "../../graphics/metal/CommandBufferMTL.h"

#include <ui/SpoopyWindowRenderer.h>
#include <SDL_metal.h>

/*
 * Having the main components like the commandBuffer in this class can cause potential issues and limitations,
 * but Lime is multithreaded so having two separate renderers, one window and one main, might be more detrimental.
 * OpenFL also has most of there rendering done by the Sprite class, which can be assigned to each window too.
 */
namespace lime {
    class SpoopyWindowRendererMTL: public SpoopyWindowRenderer {
        public:
            #ifdef SPOOPY_SDL
            SpoopyWindowRendererMTL(const SDLWindow &m_window);
            #endif

            ~SpoopyWindowRendererMTL();

            virtual void updateMetalDescriptor();
            virtual void assignMetalDevice(value __layerDevice);
            virtual void setVertexBuffer(value __buffer, int __offset, int __atIndex);
            virtual void setViewport(Rectangle* rect);
            virtual void setScissorMode(bool isEnabled, Rectangle* rect);
            virtual void useProgram(value __pipeline);
            virtual void beginRenderPass();

            virtual void render();
            virtual void clear();

            virtual void cullFace(int cullMode);
            virtual void setWinding(int winding);

            virtual CAMetalLayer* getMetalLayer() const;

            virtual const SDLWindow& getWindow() const;
        private:
            const SDLWindow &m_window;

            MTLRenderPassDescriptor* renderPassDescriptor;
            CAMetalLayer* layer;

            CommandBufferMTL* commandBuffer;

            id<CAMetalDrawable> _surface;

            float rgba[4];
    };
}