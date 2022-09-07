#ifndef SPOOPY_UI_WINDOW_H
#define SPOOPY_UI_WINDOW_H

#include <SDL.h>

#ifdef SPOOPY_METAL
#include <Foundation/Foundation.hpp>
#include <Metal/Metal.hpp>
#include <Metal/shared_ptr.hpp>
#include <QuartzCore/QuartzCore.hpp>
#endif

#ifdef SPOOPY_GLAD
#include <glad/glad.h>
#endif

namespace spoopy {
    class WindowGiver {
        public:
            virtual ~WindowGiver();

            SDL_Renderer* sdlRenderer;
			SDL_Texture* sdlTexture;
			SDL_Window* sdlWindow;
        private:
			SDL_GLContext context;
    };
}
#endif