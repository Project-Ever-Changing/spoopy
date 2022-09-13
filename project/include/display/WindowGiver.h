#ifndef SPOOPY_UI_WINDOW_H
#define SPOOPY_UI_WINDOW_H

#include <iostream>

#include <SDL.h>

#ifdef SPOOPY_VULKAN
#include <SDL_vulkan.h>
#endif

namespace spoopy {
    class WindowGiver {
        public:
            virtual ~WindowGiver();

            WindowGiver(const WindowGiver &) = delete;
            WindowGiver &operator=(const WindowGiver &) = delete;

            #ifdef SPOOPY_VULKAN
            void createWindowSurfaceVulkan(VkInstance instance, VkSurfaceKHR* surface);
            #endif

            SDL_Renderer* sdlRenderer;
			SDL_Texture* sdlTexture;
			SDL_Window* sdlWindow;
        private:
			SDL_GLContext context;
    };
}
#endif