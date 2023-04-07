#pragma once

#include <system/CFFIPointer.h>

#include <vector>

#ifdef SPOOPY_VULKAN
#include <helpers/SpoopyHelpers.h>
#endif

#ifdef SPOOPY_SDL
#include <SDLWindow.h>
#endif

namespace lime {
    class SpoopyWindowRenderer {
        public:
            virtual ~SpoopyWindowRenderer() {};

            virtual void render() = 0;
            virtual void clear() = 0;

            virtual void cullFace(int cullMode) = 0;
            virtual void setWinding(int winding) = 0;
            virtual void setVertexBuffer(value __buffer, int __offset, int __atIndex) = 0;
            virtual void setViewport(Rectangle* rect) = 0;
            virtual void setScissorMode(bool isEnabled, Rectangle* rect) = 0;
            virtual void useProgram(value __pipeline) = 0;
            virtual void beginRenderPass() = 0;

            #ifdef SPOOPY_SDL
            virtual const SDLWindow& getWindow() const = 0;
            #endif

            #ifdef SPOOPY_VULKAN
            virtual void createWindowSurfaceVulkan(VkInstance instance, VkSurfaceKHR* surface) const = 0;
            #endif

            #ifdef SPOOPY_METAL
            virtual void assignMetalDevice(value __layerDevice) = 0;
            virtual void updateMetalDescriptor() = 0;
            #endif
    };

    #ifdef SPOOPY_SDL
    SpoopyWindowRenderer* createWindowRenderer(const SDLWindow &m_window);
    #endif
}