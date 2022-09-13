#ifndef SPOOPY_UI_WINDOW_H
#define SPOOPY_UI_WINDOW_H

#include <SDL.h>
#include <SDL_vulkan.h>

namespace spoopy {
    class WindowGiver {
        public:
            virtual ~WindowGiver();

            WindowGiver(const WindowGiver &) = delete;
            WindowGiver &operator=(const WindowGiver &) = delete;

            void createWindowSurface(VkInstance instance, VkSurfaceKHR* surface);

            SDL_Renderer* sdlRenderer;
			SDL_Texture* sdlTexture;
			SDL_Window* sdlWindow;
        private:
			SDL_GLContext context;
    };
}
#endif