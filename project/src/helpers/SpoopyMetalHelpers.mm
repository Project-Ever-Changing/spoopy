#import <Foundation/Foundation.h>

#include "../bgfx_metal.h"

#ifdef SPOOPY_SDL
#include <SDL.h>
#include <SDL_metal.h>
#endif

#define MTL_CLASS(name)                                   \
	class name                                            \
	{                                                     \
	public:                                               \
		name(id <MTL##name> _obj = nil) : m_obj(_obj) {}  \
		operator id <MTL##name>() const { return m_obj; } \
		id <MTL##name> m_obj;

#define MTL_CLASS_END };

namespace lime {
    typedef id<MTLRenderPipelineState> RenderPipelineState;
    typedef MTLRenderPipelineDescriptor* RenderPipelineDescriptor;
    typedef MTLPixelFormat SpoopyPixelFormat;

    struct SpoopyMetalHelper {
        static SpoopyPixelFormat convertSDLtoMetal(Uint32 pixelFormat);
    };

    SpoopyPixelFormat SpoopyMetalHelper::convertSDLtoMetal(Uint32 pixelFormat) {
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