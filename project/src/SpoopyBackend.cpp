#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif

#include <iostream>

#include <hx/CFFI.h>
#include <hx/CFFIPrime.h>

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
    /*
    * A useless method. (for now)
    */
    void spoopy_application_init() {
        #ifdef SPOOPY_GLAD
        gladLoadGLLoader(SDL_GL_GetProcAddress); //I don't think this works.
        #endif
    }
    DEFINE_PRIME0v(spoopy_application_init);

    void spoopy_window_render(value window) {
        SDL_Window* targetWindow = (SDL_Window*)val_data(window);
    }
    DEFINE_PRIME1v(spoopy_window_render);
}