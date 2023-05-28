#pragma once

#include <SDL.h>
#include <SDL_vulkan.h>

#ifdef SPOOPY_VOLK

    #include <volk.h>

#endif

#ifdef LIME_VULKAN

    #define SDL_CreateContext lime::CreateContext
    #define SDL_DeleteContext lime::DestroyContext
    #define SDL_Context lime::ContextBase*
    #define SDL_MakeCurrent lime::MakeCurrent
    #define SDL_SetSwapInterval lime::SwapInterval

    #define SDL_SwapWindow EMPTY

    namespace lime {
        class ContextBase {};

        ContextBase* CreateContext(SDL_Window* m_window);
        void DestroyContext(ContextBase* context);
        int MakeCurrent(SDL_Window* m_window, ContextBase* context);
        int SwapInterval(int vsync);
    }
#endif