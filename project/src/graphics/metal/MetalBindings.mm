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
    static MTLResourceStorageMode storageMode;

    void lime_set_resource_storage_mode(int mode) {
        switch(mode) {
            case 0x00000002: // METAL_STORAGE_GPU_ONLY
                storageMode = MTLResourceStorageModePrivate;
                break;
            case 0x00000004: // METAL_STORAGE_MANAGED
                storageMode = MTLResourceStorageModeManaged;
                break;
            case 0x00000008: // METAL_STORAGE_MEMORY_LESS
                storageMode = MTLResourceStorageModeMemoryless;
                break;
            default: // METAL_STORAGE_SHARED
                storageMode = MTLResourceStorageModeShared;
                break;
        }
    }
    DEFINE_PRIME1v(lime_set_resource_storage_mode);
}