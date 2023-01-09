#ifndef SPOOPY_SDL_WINDOW
#define SPOOPY_SDL_WINDOW

#ifdef SPOOPY_SDL
#include <SDL.h>

namespace spoopy {
    class SpoopySDLWindow {
        public:
            SpoopySDLWindow(int width, int height, int flags, const char* title);
            ~SpoopySDLWindow();

            /*
            * Idc about using a getter for this tbh.
            */
            SDL_Window* m_window;
            //SDL_Renderer* m_Renderer;
			//SDL_Texture* m_Textures;
    };
}
#endif
#endif