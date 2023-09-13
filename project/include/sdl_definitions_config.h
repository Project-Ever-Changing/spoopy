#pragma once

#include "graphics/Context.h"

#include <SDL.h>
#include <SDL_vulkan.h>

#include <memory>

#ifdef LIME_VULKAN
    #define Context std::shared_ptr<lime::spoopy::ContextVulkan>

    #define CreateContext lime::spoopy::GraphicsHandler::CreateContext
    #define DeleteContext lime::spoopy::GraphicsHandler::DestroyContext
    #define MakeCurrent lime::spoopy::GraphicsHandler::MakeCurrent
    #define SetSwapInterval lime::spoopy::GraphicsHandler::SwapInterval

    #define SwapWindow EMPTY
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