#pragma once

#define byte(n) ((n) * 8) // 8bit

#include <SDL.h>

namespace lime {
    struct SpoopyBytes {
        static uint8_t bitsOfFormat(SDL_PixelFormatEnum format);
    };
}