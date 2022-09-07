#include "WindowGiver.h"

#include <SDL.h>

namespace spoopy {
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