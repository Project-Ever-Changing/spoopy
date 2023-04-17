#include "SpoopyMetalHelpers.h"

namespace lime {
    SpoopyPixelFormat SpoopyMetalHelpers::convertSDLtoMetal(UInt32 pixelFormat) {
        switch(pixelFormat) {
            case SDL_PIXELFORMAT_RGBA32:
            case SDL_PIXELFORMAT_ARGB8888:
                return MTLPixelFormatRGBA8Unorm;

            case SDL_PIXELFORMAT_BGRA8888:
            case SDL_PIXELFORMAT_BGRX8888:
                return MTLPixelFormatBGRA8Unorm;

            default:
                printf("Unsupported SDL_PixelFormat: 0x%X\n", pixelFormat);
                return MTLPixelFormatInvalid;
        }
    }
}