#pragma once

#include "graphics/ContextLayer.h"

#include <SDL.h>
#include <SDL_vulkan.h>

#include <memory>

#ifdef LIME_VULKAN
    #define Context std::shared_ptr<lime::spoopy::ContextVulkan>

    #define CreateContext lime::spoopy::GraphicsHandler::Handler_CreateContext
    #define DeleteContext lime::spoopy::GraphicsHandler::Handler_DestroyContext
    #define MakeCurrent lime::spoopy::GraphicsHandler::Handler_MakeCurrent
    #define SetSwapInterval lime::spoopy::GraphicsHandler::Handler_SwapInterval

    #define SwapWindow EMPTY
#endif

#ifndef LIME_OPENGL

namespace lime { namespace spoopy {
    struct GraphicsHandler {
        static Context Handler_CreateContext(SDL_Window* m_window);
        static void Handler_DestroyContext(const Context &context);
        static int Handler_MakeCurrent(SDL_Window* m_window, const Context &context);
        static int Handler_SwapInterval(bool vsync);
    };
}}

#endif