#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif

#include <iostream>

#include <system/CFFIPointer.h>
#include <device/WindowDevice.h>
#include <device/DeviceManager.h>

using namespace lime;

namespace spoopy {
    void apply_gc_window(value handle) {
        WindowDevice* window = (WindowDevice*)val_data(handle);
        delete window;
    } 

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

    void spoopy_apply_surface(value window, value device) {
        WindowDevice* targetWindow = (WindowDevice*)val_data(window);
        DeviceManager* targetDevice = (DeviceManager*)val_data(device);
        
        #ifdef SPOOPY_VULKAN
        targetWindow -> createWindowSurfaceVulkan(targetDevice -> getInstance(), targetDevice -> getSurface());
        #endif
    }
    DEFINE_PRIME2v(spoopy_apply_surface);

    value spoopy_assign_application_device(HxString name, int v, int vBeta, int vAlpha) {
        const int version[3] = {v, vBeta, vAlpha};

        DeviceManager* device = new DeviceManager();
        
        #ifdef SPOOPY_VULKAN
        device -> initAppWithVulkan(name.c_str(), version);
        device -> setupDebugMessenger();
        #endif

        return CFFIPointer(device, apply_gc_device);
    }
    DEFINE_PRIME4(spoopy_assign_application_device);

    void spoopy_assign_physical_device(value device) {
        DeviceManager* targetDevice = (DeviceManager*)val_data(device);

        #ifdef SPOOPY_VULKAN
        targetDevice -> choosePhysicalDeviceVulkan();
        #endif
    }
    DEFINE_PRIME1v(spoopy_assign_physical_device);

    void spoopy_assign_logical_device(value device) {
        DeviceManager* targetDevice = (DeviceManager*)val_data(device);

        #ifdef SPOOPY_VULKAN
        targetDevice -> createLogicalDeviceVulkan();
        #endif
    }
    DEFINE_PRIME1v(spoopy_assign_logical_device);
}