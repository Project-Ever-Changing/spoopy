#pragma once

#import "../../helpers/metal/SpoopyMetalHelpers.h"
#import "../../graphics/metal/CommandBufferMTL.h"

#include "../../graphics/metal/texture/Texture2DMTL.h"

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
            virtual void assignMetalDevice();
            virtual void setVertexBuffer(value __buffer, int __offset, int __atIndex);
            virtual void setIndexBuffer(value __buffer);
            virtual void setViewport(Rectangle* rect);
            virtual void setScissorMode(bool isEnabled, Rectangle* rect);
            virtual void setLineWidth(float width);
            virtual void useProgram(value __pipeline);
            virtual void beginRenderPass();

            virtual void render();
            virtual void clear();

            virtual void drawArrays(int primitiveType, size_t start, size_t count);
            virtual void drawElements(int primitiveType, int indexFormat, size_t count, size_t offset);

            virtual void setRenderTarget(RenderTargetFlag flags, Texture2D* colorAttachment, Texture2D* depthAttachment, Texture2D* stencilAttachment);

            virtual void cullFace(int cullMode);
            virtual void setWinding(int winding);

            virtual bool findCommandBuffer() const;
            virtual CAMetalLayer* getMetalLayer() const {return layer;};

            virtual const SDLWindow& getWindow() const;
        private:
            #ifdef SPOOPY_SDL
            const SDLWindow &m_window;
            #endif

            CommandBufferMTL* _commandBuffer;
            CAMetalLayer* layer;

            RenderPassDescriptor<Texture2DMTL> renderPassDescriptor;
            id<CAMetalDrawable> _surface;
    };
}