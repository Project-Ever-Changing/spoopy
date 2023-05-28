#pragma once

#include <sdl_definitions_config.h>
#include <algorithm>

#include "../../device/Surface.h"
#include "GraphicsVulkan.h"
#include "ContextVulkan.h"

namespace lime {
    struct GraphicsHandlerVulkan {
        static ContextBase* CreateContext(SDL_Window* m_window);
        static void DestroyContext(ContextBase* context);
        static int MakeCurrent(SDL_Window* m_window, ContextBase* context);
        static int SwapInterval(int vsync);
    };

    ContextBase* CreateContext(SDL_Window* m_window) { return GraphicsHandlerVulkan::CreateContext(m_window); }
    void DestroyContext(ContextBase* context) { GraphicsHandlerVulkan::DestroyContext(context); }
    int MakeCurrent(SDL_Window* m_window, ContextBase* context) { return GraphicsHandlerVulkan::MakeCurrent(m_window, context); }
    int SwapInterval(int vsync) { return GraphicsHandlerVulkan::SwapInterval(vsync); }
}
