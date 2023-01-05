#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif

#ifdef _WIN32

#else
    #include <dlfcn.h>
#endif

#include <iostream>
#include <cstdlib>

#include <system/CFFIPointer.h>
#include <device/InstanceDevice.h>

using namespace lime;

namespace spoopy {
    /*
    * Destruction.
    */
    void apply_gc_window(value handle) {
        SpoopyWindow* window = (SpoopyWindow*)val_data(handle);
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

        SpoopyWindow* cast_Window = (SpoopyWindow*)val_data(window);

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

    value spoopy_window_get_title(value window) {
        /*
        SpoopyWindow* targetWindow = (SpoopyWindow*)val_data (window);
        const char* title = targetWindow -> getWindowTitle();

        std::cout << title << std::endl;
        */

        return alloc_string("Test Title");

       /*
       SDL_Window* sourceWindow = (SDL_Window*)val_data(window);
       const char* title = SDL_GetWindowTitle(sourceWindow);
       return title ? alloc_string(title) : alloc_null();
       */
    }
    DEFINE_PRIME1(spoopy_window_get_title);

    /*
    * Testing Purposes
    */
    int spoopy_test_SDL() {
        #ifdef SPOOPY_SDL
        return 1;
        #endif

        #ifdef LIME_SDL
        return 2;
        #endif

        return 0;
    }
    DEFINE_PRIME0(spoopy_test_SDL);
}