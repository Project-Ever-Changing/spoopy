#ifndef SPOOPY_SDL_WINDOW
#define SPOOPY_SDL_WINDOW

#include <SpoopyHelpers.h>

#ifdef SPOOPY_SDL
#include <SDL.h>

namespace spoopy {
    class SpoopySDLWindow {
        public:
            SpoopySDLWindow(int width, int height, int flags, const char* title);
            ~SpoopySDLWindow();

            virtual int getX() const;
            virtual int getY() const;

            virtual uint32_t getID() const;
            virtual double getScale() const;

            /*
            * Idc about using a getter for this tbh.
            */
            SDL_Window* m_window;
    };
}
#endif
#endif