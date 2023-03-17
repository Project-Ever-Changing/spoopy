#include <iostream>

#include "SpoopyWindowVulkan.h"

#ifdef SPOOPY_VULKAN

namespace lime {
    SpoopyWindowVulkan::SpoopyWindowVulkan(const SDLWindow &m_window): m_window(m_window) {
        /*
        * Empty
        */
    }

    void SpoopyWindowVulkan::createWindowSurfaceVulkan(VkInstance instance, VkSurfaceKHR* surface) const {
        #ifdef SPOOPY_SDL
        if(!SDL_Vulkan_CreateSurface(m_window.sdlWindow, instance, surface)) {
            throw std::runtime_error("Failed to create Window Surface for Vulkan API!");
        }
        #endif
    }

    void SpoopyWindowVulkan::render() {
        /*
         * Empty
         */
    }

    void SpoopyWindowVulkan::clear() {
        /*
         * Empty
         */
    }

    void SpoopyWindowVulkan::setVertexBuffer(value __buffer, int __offset, int __atIndex) {
        /*
         * Empty
         */
    }

    void SpoopyWindowVulkan::cullFace(int cullMode) {
        /*
         * Empty
         */
    }

    const SDLWindow& SpoopyWindowVulkan::getWindow() const {
        return m_window;
    }


    #ifdef SPOOPY_SDL
    SpoopyWindowSurface* createWindowSurface(const SDLWindow &m_window) {
        return new SpoopyWindowVulkan(m_window);
    }
    #endif
}

#endif