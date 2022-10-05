#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif

#include <iostream>
#include <string>

#include <system/CFFIPointer.h>
#include <device/WindowDevice.h>
#include <device/DeviceManager.h>

using namespace lime;

namespace spoopy {
    void apply_gc_device(value handle) {
        DeviceManager* device = (DeviceManager*)val_data(handle);
        delete device;
    } 

    /*
    * A useless method. (for now)
    */
    void spoopy_application_init() {
        #ifdef COMPILED_LIBS
        std::cout << "yay! celebrate!" << std::endl;
        #endif
    }
    DEFINE_PRIME0v(spoopy_application_init);

    void spoopy_window_render(value window) {
        WindowDevice* targetWindow = (WindowDevice*)val_data(window);
    }
    DEFINE_PRIME1v(spoopy_window_render);

    value spoopy_device_create() {
        DeviceManager* device = new DeviceManager();
        return CFFIPointer(device, apply_gc_device);
    }
    DEFINE_PRIME0(spoopy_device_create);

    value spoopy_assign_application_device(HxString name, int v, int vBeta, int vAlpha) {
        const int version[3] = {v, vBeta, vAlpha};

        DeviceManager* device = new DeviceManager();
        
        #ifdef SPOOPY_VULKAN
        device -> initAppWithVulkan(name.c_str(), version);
        #endif

        return CFFIPointer(device, apply_gc_device);
    }
    DEFINE_PRIME4(spoopy_assign_application_device);
}