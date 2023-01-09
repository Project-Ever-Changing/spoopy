#ifdef SPOOPY_SDL
#include <sdl/SpoopySDLWindow.h>

#ifdef HX_WINDOWS
#include <SDL_syswm.h>
#include <Windows.h>
#endif

namespace spoopy {
	/*
	* Heavily modified version of Lime's SDLWindow to support vulkan only.
	* https://github.com/openfl/lime/blob/develop/project/src/backend/sdl/SDLWindow.cpp
	*/
    SpoopySDLWindow::SpoopySDLWindow(int width, int height, int flags, const char* title) {

		/*
		* Flags
		*/
        int sdlFlags = 0;

		if(flags & SDL_WINDOW_FULLSCREEN_DESKTOP) sdlFlags |= SDL_WINDOW_FULLSCREEN_DESKTOP;
		if(flags & SDL_WINDOW_RESIZABLE) sdlFlags |= SDL_WINDOW_RESIZABLE;
		if(flags & SDL_WINDOW_BORDERLESS) sdlFlags |= SDL_WINDOW_BORDERLESS;
		if(flags & SDL_WINDOW_HIDDEN) sdlFlags |= SDL_WINDOW_HIDDEN;
		if(flags & SDL_WINDOW_MINIMIZED) sdlFlags |= SDL_WINDOW_MINIMIZED;
		if(flags & SDL_WINDOW_MAXIMIZED) sdlFlags |= SDL_WINDOW_MAXIMIZED;
		if(flags & SDL_WINDOW_ALLOW_HIGHDPI) sdlFlags |= SDL_WINDOW_ALLOW_HIGHDPI;

        #ifndef EMSCRIPTEN
		if(flags & SDL_WINDOW_ALWAYS_ON_TOP) sdlFlags |= SDL_WINDOW_ALWAYS_ON_TOP;
		#endif

		#if defined(SPOOPY_VULKAN) && !defined(EMSCRIPTEN)
		if(flags & SDL_WINDOW_VULKAN) sdlFlags |= SDL_WINDOW_VULKAN;
		#endif

		/*
		* Hints
		*/
		#if !defined(EMSCRIPTEN)
		SDL_SetHint(SDL_HINT_ANDROID_TRAP_BACK_BUTTON, "0");
		SDL_SetHint(SDL_HINT_MOUSE_FOCUS_CLICKTHROUGH, "1");
		SDL_SetHint(SDL_HINT_MOUSE_TOUCH_EVENTS, "0");
		SDL_SetHint(SDL_HINT_TOUCH_MOUSE_EVENTS, "1");
		#endif

		/*
		* Create Window
		*/
		m_window = SDL_CreateWindow(title, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, width, height, sdlFlags);
    }

	int SpoopySDLWindow::getX() {
		int x, y;
		SDL_GetWindowPosition(m_window, &x, &y);
		return x;
	}

	int SpoopySDLWindow::getY() const {
		int x, y;
		SDL_GetWindowPosition(m_window, &x, &y);
		return y;
	}

	uint32_t SpoopySDLWindow::getID() const {
		return SDL_GetWindowID(m_window);
	}

    SpoopySDLWindow::~SpoopySDLWindow() const {
		if(m_window != nullptr) {
			SDL_DestroyWindow (m_window);
			m_window = 0;
		}
    }
}
#endif