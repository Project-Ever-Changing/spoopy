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
        int sdlFlags = 0;

		if (flags & SDL_WINDOW_FULLSCREEN_DESKTOP) sdlFlags |= SDL_WINDOW_FULLSCREEN_DESKTOP;
		if (flags & SDL_WINDOW_RESIZABLE) sdlFlags |= SDL_WINDOW_RESIZABLE;
		if (flags & SDL_WINDOW_BORDERLESS) sdlFlags |= SDL_WINDOW_BORDERLESS;
		if (flags & SDL_WINDOW_HIDDEN) sdlFlags |= SDL_WINDOW_HIDDEN;
		if (flags & SDL_WINDOW_MINIMIZED) sdlFlags |= SDL_WINDOW_MINIMIZED;
		if (flags & SDL_WINDOW_MAXIMIZED) sdlFlags |= SDL_WINDOW_MAXIMIZED;

        #ifndef EMSCRIPTEN
		if (flags & SDL_WINDOW_ALWAYS_ON_TOP) sdlFlags |= SDL_WINDOW_ALWAYS_ON_TOP;
		#endif

		#if defined(SPOOPY_VULKAN) && !defined(EMSCRIPTEN)
		//if(flags & W)
		#endif

    }

    SpoopySDLWindow::~SpoopySDLWindow() {

    }
}