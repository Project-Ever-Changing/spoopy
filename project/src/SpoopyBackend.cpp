#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif

#include <iostream>

#include <system/CFFIPointer.h>
#include <device/InstanceDevice.h>

//#include <volk.c>

using namespace lime;

namespace spoopy {
    /*
    * Destruction.
    */
    void apply_gc_window(value handle) {
        Window* window = (Window*)val_data(handle);
        delete window;
    }

    void apply_gc_instance_device(value handle) {
        InstanceDevice* instanceDevice = (InstanceDevice*)val_data(handle);
        delete instanceDevice;
    }

    /*
    * Creation
    */
    value spoopy_create_instance_device(value window, HxString name, int major, int minor, int patch) {
        const int version[3] = {major, minor, patch};

        Window* cast_Window = (Window*)val_data(window);

        InstanceDevice* instanceDevice = new InstanceDevice(*cast_Window);
        instanceDevice -> createInstance(name.c_str(), version);
        instanceDevice -> createDebugMessenger();

        return CFFIPointer(instanceDevice, apply_gc_instance_device);
    }
    DEFINE_PRIME5(spoopy_create_instance_device);

    /*
    * Other
    */
    void spoopy_application_init() {
        #ifdef COMPILED_LIBS
        std::cout << "initialized application!" << std::endl;
        #endif
    }
    DEFINE_PRIME0v(spoopy_application_init);

    void spoopy_apply_surface(value window, value device) {

    }
    DEFINE_PRIME2v(spoopy_apply_surface);
}