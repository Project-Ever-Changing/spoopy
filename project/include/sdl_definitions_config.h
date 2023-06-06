#pragma once

#include <SDL.h>
#include <SDL_vulkan.h>

#ifdef LIME_VULKAN
    #define SDL_Context lime::spoopy::ContextBase*

    #define SDL_CreateContext lime::spoopy::GraphicsHandler::CreateContext
    #define SDL_DeleteContext lime::spoopy::GraphicsHandler::DestroyContext
    #define SDL_MakeCurrent lime::spoopy::GraphicsHandler::MakeCurrent
    #define SDL_SetSwapInterval lime::spoopy::GraphicsHandler::SwapInterval

    #define SDL_SwapWindow EMPTY
#endif

#ifndef LIME_OPENGL

namespace lime { namespace spoopy {
    class ContextBase {};

    struct GraphicsHandler {
        static ContextBase* CreateContext(SDL_Window* m_window);
        static void DestroyContext(ContextBase* context);
        static int MakeCurrent(SDL_Window* m_window, ContextBase* context);
        static int SwapInterval(int vsync);
    };
}}

#endif