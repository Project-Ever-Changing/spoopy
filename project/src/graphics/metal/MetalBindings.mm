#include <iostream>
#include <cstdlib>

#include <system/CFFIPointer.h>

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
    static MTLStorageMode storageMode;

    enum METAL_RESOURCE_STORAGE_MODE {
        METAL_STORAGE_SHARED = 0x00000000,
        METAL_STORAGE_GPU_ONLY = 0x00000002,
        METAL_STORAGE_MANAGED = 0x00000004,
        METAL_STORAGE_MEMORY_LESS = 0x00000008,
    };

    void spoopy_set_resource_storage_mode(int mode) {
        switch(mode) {
            case METAL_STORAGE_GPU_ONLY:
                storageMode = MTLResourceStorageModePrivate;
                break;
            case METAL_STORAGE_MANAGED:
                storageMode = MTLResourceStorageModeManaged;
                break;
            case METAL_STORAGE_MEMORY_LESS:
                if(@available(iOS 12.0, *)) {
                    storageMode = MTLResourceStorageModeMemoryless;
                }else {
                    printf("[WARN] METAL_STORAGE_MEMORY_LESS is not avaible for platform.\n");
                }

                break;
            default: // METAL_STORAGE_SHARED
                storageMode = MTLResourceStorageModeShared;
                break;
        }
    }
    DEFINE_PRIME1v(spoopy_set_resource_storage_mode);
}