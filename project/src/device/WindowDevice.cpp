#include "WindowDevice.h"

namespace spoopy {
    #ifdef SPOOPY_VULKAN
    void WindowDevice::createWindowSurfaceVulkan(VkInstance instance, VkSurfaceKHR* surface) {
        if(SDL_Vulkan_CreateSurface(sdlWindow, instance, surface) != VK_SUCCESS) {
            throw std::runtime_error("Failed to create Window Surface for Vulkan API!");
        }
    }
    #endif

    WindowDevice::~WindowDevice() {
        if(sdlWindow != nullptr) {
            SDL_DestroyWindow(sdlWindow);
            sdlWindow = 0;
        }

        if (sdlRenderer != nullptr) {
            SDL_DestroyRenderer(sdlRenderer);
        }else if(context) {
            SDL_GL_DeleteContext(context);
        }
    }
}