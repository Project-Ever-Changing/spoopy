#pragma once

#include <SDL.h>
#include <SDL_syswm.h>
#include <spoopy.h>

namespace spoopy_mac {
    bool MacCreateSurface(SDL_Window* window, VkInstance instance, VkSurfaceKHR* surface);
}