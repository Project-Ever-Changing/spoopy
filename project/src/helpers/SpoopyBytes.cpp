#include <helpers/SpoopyBytes.h>

namespace lime { namespace spoopy {
    uint8_t SpoopyBytes::bitsOfFormat(SDL_PixelFormatEnum format) {
        switch(format) {
            case SDL_PIXELFORMAT_RGBA8888:
            case SDL_PIXELFORMAT_BGRA8888:
            case SDL_PIXELFORMAT_BGRX8888:
            case SDL_PIXELFORMAT_RGBA32:
                return byte(4);
            case SDL_PIXELFORMAT_RGB888:
                return byte(3);
            case SDL_PIXELFORMAT_RGBA4444:
                return byte(2);
            case SDL_PIXELFORMAT_RGB565:
                return byte(2);
            default:
                return byte(0);
        }

        return 0;
    }
}}