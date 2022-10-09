#ifndef SPOOPY_UI_WINDOW_H
#define SPOOPY_UI_WINDOW_H

#include <iostream>

#include <SDL.h>

#ifdef SPOOPY_VULKAN
    #include <SDL_vulkan.h>
    #include <vulkan/vulkan.h>
    #include <vulkan/vulkan_core.h>

    #ifdef SPOOPY_WIN32
        #include <vulkan/vulkan_win32.h>
    #endif
#endif

namespace spoopy {
    class Window {
        public:
            virtual ~Window();

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