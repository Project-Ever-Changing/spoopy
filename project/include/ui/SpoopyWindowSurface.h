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
    class SpoopyWindowSurface {
        public:
            virtual ~SpoopyWindowSurface() {};

            virtual void render() = 0;
            virtual void clear() = 0;

            #ifdef SPOOPY_SDL
            virtual const SDLWindow& getWindow() const = 0;
            #endif

            #ifdef SPOOPY_VULKAN
            virtual void createWindowSurfaceVulkan(VkInstance instance, VkSurfaceKHR* surface) const = 0;
            #endif

            #ifdef SPOOPY_METAL
            virtual void assignMetalDevice(value __layerDevice) = 0;
            virtual void setVertexBuffer(value __buffer, int offset, int atIndex) = 0;
            #endif
    };

    #ifdef SPOOPY_SDL
    SpoopyWindowSurface* createWindowSurface(const SDLWindow &m_window);
    #endif
}