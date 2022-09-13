#include "WindowGiver.h"

namespace spoopy {
    #ifdef SPOOPY_VULKAN
    void WindowGiver::createWindowSurfaceVulkan(VkInstance instance, VkSurfaceKHR* surface) {
        if(SDL_Vulkan_CreateSurface(sdlWindow, instance, surface) != VK_SUCCESS) {
            throw std::runtime_error("Failed to create Window Surface for Vulkan API!");
        }
    }
    #endif

    WindowGiver::~WindowGiver() {
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