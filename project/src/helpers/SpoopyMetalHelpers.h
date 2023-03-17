#pragma once

#ifdef HX_MACOS
#include <Cocoa/Cocoa.h>
#else
#import <UIKit/UIKit.h>
#endif

#import <QuartzCore/CAMetalLayer.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

#ifdef SPOOPY_SDL
#include <SDL.h>
#include <SDL_metal.h>
#endif

namespace lime {
    typedef MTLRenderPipelineDescriptor *SpoopyPipelineDescriptor;
    typedef id <MTLRenderPipelineState> SpoopyPipelineState;
    typedef MTLPixelFormat SpoopyPixelFormat;

    struct SpoopyMetalHelpers {
        static SpoopyPixelFormat convertSDLtoMetal(Uint32 pixelFormat);
    };

    inline void release(NSObject* _obj) {
        [_obj release];
    }

    inline void reset(SpoopyPipelineDescriptor _obj)  {
        [_obj reset];
    }
}