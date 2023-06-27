#pragma once

#include "graphics/Context.h"

#include <SDL.h>
#include <SDL_vulkan.h>

#include <memory>

#ifdef LIME_VULKAN
    #define SDL_Context std::shared_ptr<lime::spoopy::ContextVulkan>

    #define SDL_CreateContext lime::spoopy::GraphicsHandler::CreateContext
    #define SDL_DeleteContext lime::spoopy::GraphicsHandler::DestroyContext
    #define SDL_MakeCurrent lime::spoopy::GraphicsHandler::MakeCurrent
    #define SDL_SetSwapInterval lime::spoopy::GraphicsHandler::SwapInterval

    #define SDL_SwapWindow EMPTY
#endif

#ifndef LIME_OPENGL

namespace lime { namespace spoopy {
    struct GraphicsHandler {
        static SDL_Context CreateContext(SDL_Window* m_window);
        static void DestroyContext(const SDL_Context &context);
        static int MakeCurrent(SDL_Window* m_window, const SDL_Context &context);
        static int SwapInterval(int vsync);
    };
}}

#endif