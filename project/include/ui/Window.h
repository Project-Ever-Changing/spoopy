#ifndef SPOOPY_UI_WINDOW_H
#define SPOOPY_UI_WINDOW_H

#include <vector>

#ifdef SPOOPY_SDL
#include <SDL.h>
#endif

#include <SpoopyHelpers.h>

namespace spoopy {
    class Window {
        public:
            virtual ~Window();

            #ifdef SPOOPY_VULKAN
            virtual void createWindowSurfaceVulkan(VkInstance instance, VkSurfaceKHR* surface) const;
            virtual uint32_t getExtensionCount() const;
            virtual std::vector<const char*> getInstanceExtensions(uint32_t extensionCount) const;

            virtual bool foundedInstanceExtensions() const {return foundInstanceExtensions;}
            #endif

            #ifdef SPOOPY_SDL
            SDL_Renderer* sdlRenderer;
			SDL_Texture* sdlTexture;
			SDL_Window* sdlWindow;
            #endif
        private:
            #ifdef SPOOPY_SDL
			SDL_GLContext context;
            #endif

            const bool foundInstanceExtensions = false;
    };
}
#endif