#pragma once

#ifdef HX_MACOS
#include <Cocoa/Cocoa.h>
#else
#import <UIKit/UIKit.h>
#endif

#ifdef SPOOPY_SDL
#include <SDL.h>
#include <SDL_metal.h>
#endif

#include <system/CFFIPointer.h>

#import <QuartzCore/CAMetalLayer.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

namespace lime {
    typedef MTLRenderPipelineDescriptor *SpoopyPipelineDescriptor;
    typedef id<MTLRenderPipelineState> SpoopyPipelineState;
    typedef MTLPixelFormat SpoopyPixelFormat;

    struct SpoopyMetalHelpers {
        static SpoopyPixelFormat convertSDLtoMetal(UInt32 pixelFormat);
    };

    inline void release(NSObject* _obj) {
        [_obj release];
    }

    inline void retain(NSObject* _obj)  {
        [_obj retain];
    }

    inline void reset(SpoopyPipelineDescriptor _obj)  {
        [_obj reset];
    }

    inline void enqueue(id<MTLCommandBuffer> _obj) {
        [_obj enqueue];
    }

    inline void apply_gc_render_pipeline(value handle) {
        SpoopyPipelineState ps = (SpoopyPipelineState)val_data(handle);
        release(ps);
    }
}