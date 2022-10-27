#include <iostream>

#include <ui/Window.h>

namespace spoopy {
    #ifdef SPOOPY_VULKAN
    void Window::createWindowSurfaceVulkan(VkInstance instance, VkSurfaceKHR* surface) const {
        if(!SDL_Vulkan_CreateSurface(sdlWindow, instance, surface)) {
            throw std::runtime_error("Failed to create Window Surface for Vulkan API!");
        }
    }

    Window::~Window() {
        
    }
    #endif
}