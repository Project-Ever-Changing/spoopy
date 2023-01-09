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

		if (flags & WINDOW_FLAG_FULLSCREEN) sdlFlags |= SDL_WINDOW_FULLSCREEN_DESKTOP;
		if (flags & WINDOW_FLAG_RESIZABLE) sdlFlags |= SDL_WINDOW_RESIZABLE;
		if (flags & WINDOW_FLAG_BORDERLESS) sdlFlags |= SDL_WINDOW_BORDERLESS;
		if (flags & WINDOW_FLAG_HIDDEN) sdlFlags |= SDL_WINDOW_HIDDEN;
		if (flags & WINDOW_FLAG_MINIMIZED) sdlFlags |= SDL_WINDOW_MINIMIZED;
		if (flags & WINDOW_FLAG_MAXIMIZED) sdlFlags |= SDL_WINDOW_MAXIMIZED;

        #ifndef EMSCRIPTEN
		if (flags & WINDOW_FLAG_ALWAYS_ON_TOP) sdlFlags |= SDL_WINDOW_ALWAYS_ON_TOP;
		#endif

		#if defined(SPOOPY_VULKAN) && !defined(EMSCRIPTEN)
		//if(flags & W)
		#endif

    }

    SpoopySDLWindow::~SpoopySDLWindow() {

    }
}