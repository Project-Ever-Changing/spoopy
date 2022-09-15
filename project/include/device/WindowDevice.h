#ifndef SPOOPY_UI_WINDOW_H
#define SPOOPY_UI_WINDOW_H

#include <iostream>

#include <SDL.h>

#ifdef SPOOPY_VULKAN
#include <SDL_vulkan.h>
//#include <vulkan/vulkan.h>
//#include <vulkan/vulkan_core.h>
#endif

namespace spoopy {
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