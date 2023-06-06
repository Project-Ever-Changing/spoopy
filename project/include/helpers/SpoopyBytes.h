#pragma once

#define byte(n) ((n) * 8) // 8bit

#include <SDL.h>

namespace lime { namespace spoopy {
    struct SpoopyBytes {
        static uint8_t bitsOfFormat(SDL_PixelFormatEnum format);
    };
}}