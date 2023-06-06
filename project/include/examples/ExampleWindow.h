#pragma once

#ifdef SPOOPY_INCLUDE_EXAMPLE

    #ifdef LIME_SDL_LIB
    #include <SDL2/SDL.h>
    #elif LIME_SDL
    #include <SDL.h>
    #endif

    #ifdef SPOOPY_VOLK
    #include <volk.h>
    #endif

    namespace lime { namespace spoopy {
        class ExampleWindow {
            public:
                ExampleWindow(const char* title, int width, int height, int flags);
                ~ExampleWindow();
            private:
                #ifdef SPOOPY_SDL
                SDL_Window* sdl_window;
                #endif
        };
    }}

#endif