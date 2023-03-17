#include <iostream>
#include <cstring>
#include <cstdlib>

#include <core/Size.h>

#import <ui/SpoopyWindowSurface.h>

#ifdef HX_MACOS
#import <Cocoa/Cocoa.h>
#else
#import <UIKit/UIKit.h>
#endif

#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

namespace lime {
    static MTLStorageMode storageMode = MTLResourceStorageModePrivate;

    enum METAL_RESOURCE_STORAGE_MODE {
        METAL_STORAGE_SHARED = 0x00000000,
        METAL_STORAGE_GPU_ONLY = 0x00000002,
        METAL_STORAGE_MANAGED = 0x00000004
    };

    void spoopy_set_resource_storage_mode(int mode) {
        switch(mode) {
            case METAL_STORAGE_GPU_ONLY:
                storageMode = MTLResourceStorageModePrivate;
                break;
            case METAL_STORAGE_MANAGED:
                storageMode = MTLResourceStorageModeManaged;
                break;
            default: // METAL_STORAGE_SHARED
                storageMode = MTLResourceStorageModeShared;
                break;
        }
    }
    DEFINE_PRIME1v(spoopy_set_resource_storage_mode);


    /*
    * Objects
    */

    void spoopy_gc_buffer(value handle) {
        id<MTLBuffer> buffer = (id<MTLBuffer>)val_data(handle);

        [buffer release];
        buffer = nil;
    }

    void spoopy_gc_device(value handle) {
        id<MTLDevice> device = (id<MTLDevice>)val_data(handle);

        [device release];
        device = nil;
    }

    value spoopy_create_metal_default_device() {
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        return CFFIPointer(device, spoopy_gc_device);
    }
    DEFINE_PRIME0(spoopy_create_metal_default_device);

    value spoopy_create_metal_buffer(value metal_device, double data, int size) {
        id<MTLDevice> device = (id<MTLDevice>)val_data(metal_device);

        id<MTLBuffer> buffer = [device newBufferWithBytes:(void*)(uintptr_t)data length:size options:storageMode];
        return CFFIPointer(buffer, spoopy_gc_buffer);
    }
    DEFINE_PRIME3(spoopy_create_metal_buffer);

    int spoopy_get_buffer_length_bytes(value metal_buffer) {
        id<MTLBuffer> buffer = (id<MTLBuffer>)val_data(metal_buffer);
        return (int)buffer.length;
    }
    DEFINE_PRIME1(spoopy_get_buffer_length_bytes);

    void spoopy_copy_buffer_to_buffer(value source_buffer, value destination_buffer, int size) {
        id<MTLBuffer> sourceBuffer = (id<MTLBuffer>)val_data(source_buffer);
        id<MTLBuffer> destinationBuffer = (id<MTLBuffer>)val_data(destination_buffer);

        memcpy([destinationBuffer contents], [sourceBuffer contents], (SP_UInt)size);
    }
    DEFINE_PRIME3v(spoopy_copy_buffer_to_buffer);

    void spoopy_set_color_format(value window_surface, int format) {

    }
}