#include <sdl/SpoopySDLWindow.h>

#ifdef HX_WINDOWS
#include <SDL_syswm.h>
#include <Windows.h>
#endif

namespace spoopy {
	/*
	* Modified version of Lime's SDLWindow.
	* https://github.com/openfl/lime/blob/develop/project/src/backend/sdl/SDLWindow.cpp
	*/
    SpoopySDLWindow::SpoopySDLWindow(int width, int height, int flags, const char* title) {

		/*
		* Flags
		*/
        int sdlWindowFlags = 0;

		if (flags & WINDOW_FLAG_FULLSCREEN) sdlWindowFlags |= SDL_WINDOW_FULLSCREEN_DESKTOP;
		if (flags & WINDOW_FLAG_RESIZABLE) sdlWindowFlags |= SDL_WINDOW_RESIZABLE;
		if (flags & WINDOW_FLAG_BORDERLESS) sdlWindowFlags |= SDL_WINDOW_BORDERLESS;
		if (flags & WINDOW_FLAG_HIDDEN) sdlWindowFlags |= SDL_WINDOW_HIDDEN;
		if (flags & WINDOW_FLAG_MINIMIZED) sdlWindowFlags |= SDL_WINDOW_MINIMIZED;
		if (flags & WINDOW_FLAG_MAXIMIZED) sdlWindowFlags |= SDL_WINDOW_MAXIMIZED;

        #ifndef EMSCRIPTEN
		if (flags & WINDOW_FLAG_ALWAYS_ON_TOP) sdlWindowFlags |= SDL_WINDOW_ALWAYS_ON_TOP;
		#endif

		#ifdef SPOOPY_VULKAN
		//if(flags & W)
		#endif

    }

    SpoopySDLWindow::~SpoopySDLWindow() {

    }
}