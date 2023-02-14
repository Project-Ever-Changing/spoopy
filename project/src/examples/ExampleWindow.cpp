#include <examples/ExampleWindow.h>
#include <core/Log.h>

namespace lime {
    ExampleWindow::ExampleWindow(const char* title, int width, int height, int flags) {
        #ifdef LIME_SDL_LIB

        SPOOPY_LOG_INFO("Using SDL library");
        
        #endif

        #ifdef SPOOPY_SDL

        flags |= SDL_WINDOW_SHOWN;

        sdl_window = SDL_CreateWindow(title, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, flags);
        SPOOPY_LOG_INFO("Created an example window");

        if(!sdl_window) {
            printf("Could not create SDL window: %s.\n", SDL_GetError());
        }

        #endif
    }

    ExampleWindow::~ExampleWindow() {
        #ifdef SPOOPY_SDL

        if(sdl_window != nullptr) {
            SDL_DestroyWindow(sdl_window);
            sdl_window = 0;
        }

        #endif
    }
}