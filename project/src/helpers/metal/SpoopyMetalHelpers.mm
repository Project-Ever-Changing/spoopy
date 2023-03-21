#include "SpoopyMetalHelpers.h"

namespace lime {
    SpoopyPixelFormat SpoopyMetalHelpers::convertSDLtoMetal(Uint32 pixelFormat) {
        SpoopyPixelFormat mpf = 0;

        switch(pixelFormat) {
            case SDL_PIXELFORMAT_ARGB8888:
                mpf = MTLPixelFormatBGRA8Unorm;
                break;
            case SDL_PIXELFORMAT_BGR888:
                mpf = MTLPixelFormatBGRA8Unorm;
                break;
            case SDL_PIXELFORMAT_BGRX8888:
                mpf = MTLPixelFormatBGRA8Unorm_sRGB;
                break;
            default:
                mpf = MTLPixelFormatRGBA8Unorm;
                break;
        }

        return mpf;
    }
}