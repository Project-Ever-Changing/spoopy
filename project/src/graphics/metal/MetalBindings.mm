#include <iostream>
#include <cstring>
#include <cstdlib>

#include <core/Size.h>

#import "../../ui/metal/SpoopyWindowRendererMTL.h"
#import "../../helpers/metal/SpoopyMetalHelpers.h"
#import "../../graphics/metal/BufferMTL.h"

namespace lime {
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

        release(buffer);
    }

    void spoopy_gc_device(value handle) {
        id<MTLDevice> device = (id<MTLDevice>)val_data(handle);

        release(device);
    }

    value spoopy_get_metal_device_from_layer(value surface, bool debug) {
        SpoopyWindowRenderer* window_surface = (SpoopyWindowRenderer*)val_data(surface);
        SpoopyWindowRendererMTL* window_renderer = static_cast<SpoopyWindowRendererMTL*>(window_surface);
        id<MTLDevice> _mtlDevice = window_renderer -> getMetalLayer().device;

        if(debug) {
            printf("%s", "Getting metal device from layer\n");
        }

        return CFFIPointer(_mtlDevice, spoopy_gc_device);
    }
    DEFINE_PRIME2(spoopy_get_metal_device_from_layer);

    value spoopy_create_metal_buffer(value metal_device, double data, int size) {
        id<MTLDevice> device = (id<MTLDevice>)val_data(metal_device);

        id<MTLBuffer> buffer = [device newBufferWithBytes:(void*)(uintptr_t)data length:size options:storageMode];
        return CFFIPointer(buffer, spoopy_gc_buffer);
    }
    DEFINE_PRIME3(spoopy_create_metal_buffer);
}