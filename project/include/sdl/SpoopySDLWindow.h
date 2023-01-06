#ifdef SPOOPY_SDL
#include <SDL.h>
#endif

namespace spoopy {
    class SpoopySDLWindow {
        SpoopySDLWindow(int width, int height, int flags, const char* title);
        ~SpoopySDLWindow();
    };
}