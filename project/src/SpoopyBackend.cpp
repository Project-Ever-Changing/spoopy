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
    void apply_gc_window(value handle) {
        Window* window = (Window*)val_data(handle);
        delete window;
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

    }
    DEFINE_PRIME2v(spoopy_apply_surface);

    value spoopy_create_surface_device(HxString name, int major, int minor, int patch) {
        const int version[3] = {major, minor, patch};
        return nullptr;
    }
}