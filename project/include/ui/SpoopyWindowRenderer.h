#pragma once

#include <system/CFFIPointer.h>
#include <graphics/Texture.h>
#include <core/Log.h>

#include <vector>

#ifdef SPOOPY_VULKAN
#include <helpers/SpoopyHelpers.h>
#endif

#ifdef SPOOPY_SDL
#include <SDLWindow.h>
#endif

namespace lime {
    enum RenderTargetFlag: uint8_t {
        COLOR = 1,
        DEPTH = 1 << 1,
        STENCIL = 1 << 2,
        ALL = COLOR | DEPTH | STENCIL
    };

    class SpoopyWindowRenderer {
        public:
            virtual ~SpoopyWindowRenderer() {};

            virtual void render() = 0;
            virtual void clear() = 0;

            virtual void setVertexBuffer(value __buffer, int __offset, int __atIndex) = 0;
            virtual void setIndexBuffer(value __buffer) = 0;
            virtual void setViewport(Rectangle* rect) = 0;
            virtual void setScissorMode(bool isEnabled, Rectangle* rect) = 0;
            virtual void setLineWidth(float width) = 0;
            virtual void useProgram(value __pipeline) = 0;
            virtual void beginRenderPass() = 0;

            virtual void drawArrays(int primitiveType, size_t start, size_t count) = 0;
            virtual void drawElements(int primitiveType, int indexFormat, size_t count, size_t offset) = 0;

            virtual void setRenderTarget(RenderTargetFlag flags, Texture2D* colorAttachment, Texture2D* depthAttachment, Texture2D* stencilAttachment) = 0;

            virtual bool findCommandBuffer() const = 0;

            virtual void cullFace(int cullMode) = 0;
            virtual void setWinding(int winding) = 0;

            #ifdef SPOOPY_SDL
            virtual const SDLWindow& getWindow() const = 0;
            #endif

            #ifdef SPOOPY_VULKAN
            virtual void createWindowSurfaceVulkan(VkInstance instance, VkSurfaceKHR* surface) const = 0;
            #endif

            #ifdef SPOOPY_METAL
            virtual void assignMetalInstructions() = 0;
            #endif
        protected:
            Rectangle* _viewport;
            Rectangle* _scissor;

            bool _enabledScissor;

            int _cullMode;
            int _winding;

            RenderTargetFlag _renderTargetFlag;
    };

    #ifdef SPOOPY_SDL
    SpoopyWindowRenderer* createWindowRenderer(const SDLWindow &m_window);
    #endif
}