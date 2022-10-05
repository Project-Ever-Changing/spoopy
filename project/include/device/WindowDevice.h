#ifndef SPOOPY_UI_WINDOW_H
#define SPOOPY_UI_WINDOW_H

#include <iostream>

#include <SDL.h>

#ifdef SPOOPY_VULKAN
#include <SDL_vulkan.h>
#include <vulkan/vulkan.h>
#include <vulkan/vulkan_core.h>
#endif

namespace spoopy {
    #ifdef SPOOPY_VULKAN
    static VKAPI_ATTR VkBool32 VKAPI_CALL debugCallback(
        VkDebugUtilsMessageSeverityFlagBitsEXT messageSeverity,
        VkDebugUtilsMessageTypeFlagsEXT messageType,
        const VkDebugUtilsMessengerCallbackDataEXT *pCallbackData,
        void *pUserData) {
        std::cerr << "validation layer: " << pCallbackData->pMessage << std::endl;

        return VK_FALSE;
    }
    #endif

    class WindowDevice {
        public:
            virtual ~WindowDevice();

            #ifdef SPOOPY_VULKAN
            virtual void createWindowSurfaceVulkan(VkInstance instance, VkSurfaceKHR* surface);
            #endif

            SDL_Renderer* sdlRenderer;
			SDL_Texture* sdlTexture;
			SDL_Window* sdlWindow;
        private:
			SDL_GLContext context;
    };
}
#endif