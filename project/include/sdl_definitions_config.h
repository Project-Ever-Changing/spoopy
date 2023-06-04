#pragma once

#include <SDL.h>
#include <SDL_vulkan.h>

#define SDL_Context lime::ContextBase*

#ifdef LIME_VULKAN
    #define SDL_CreateContext lime::GraphicsHandler::CreateContext
    #define SDL_DeleteContext lime::GraphicsHandler::DestroyContext
    #define SDL_MakeCurrent lime::GraphicsHandler::MakeCurrent
    #define SDL_SetSwapInterval lime::GraphicsHandler::SwapInterval

    #define SDL_SwapWindow EMPTY
#endif

#ifndef LIME_OPENGL

namespace lime {
    class ContextBase {};

    struct GraphicsHandler {
        static ContextBase* CreateContext(SDL_Window* m_window);
        static void DestroyContext(ContextBase* context);
        static int MakeCurrent(SDL_Window* m_window, ContextBase* context);
        static int SwapInterval(int vsync);
    };
}

#endif