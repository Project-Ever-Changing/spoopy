#ifndef INITIALIZED_SPOOPY_BACKEND
    #ifndef STATIC_LINK
    #define IMPLEMENT_API
    #endif

    #if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
    #define NEKO_COMPATIBLE
    #endif

    #define INITIALIZED_SPOOPY_BACKEND
#endif

#include <iostream>
#include <cstdlib>

#include <system/CFFIPointer.h>
#include <device/InstanceDevice.h>
#include <device/LogicalDevice.h>
#include <device/PhysicalDevice.h>
#include <device/SurfaceDevice.h>

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

    void apply_gc_physical_device(value handle) {
        PhysicalDevice* physicalDevice = (PhysicalDevice*)val_data(handle);
        delete physicalDevice;
    }

    void apply_gc_logical_device(value handle) {
        LogicalDevice* logicalDevice = (LogicalDevice*)val_data(handle);
        delete logicalDevice;
    }

    void apply_gc_surface(value handle) {
        SurfaceDevice* surface = (SurfaceDevice*)val_data(handle);
        delete surface;
    }

    /*
    * Creation
    */
    value spoopy_create_window(int width, int height, int flags, HxString title) {
        SpoopyWindow* window = new SpoopyWindow(width, height, flags, title.c_str());
        return CFFIPointer(window, apply_gc_window);
    }
    DEFINE_PRIME4(spoopy_create_window);

    value spoopy_create_instance_device(value window, HxString name, int major, int minor, int patch) {
        const int version[3] = {major, minor, patch};

        SpoopyWindow* cast_Window = (SpoopyWindow*)val_data(window);

        InstanceDevice* instanceDevice = new InstanceDevice(*cast_Window);
        instanceDevice -> createInstance(name.c_str(), version);
        instanceDevice -> createDebugMessenger();

        return CFFIPointer(instanceDevice, apply_gc_instance_device);
    }
    DEFINE_PRIME5(spoopy_create_instance_device);

    value spoopy_create_physical_device(value instance) {
        InstanceDevice* cast_Instance = (InstanceDevice*)val_data(instance);

        PhysicalDevice* physical = new PhysicalDevice(*cast_Instance);
        return CFFIPointer(physical, apply_gc_window);
    }
    DEFINE_PRIME1(spoopy_create_physical_device);

    value spoopy_create_logical_device(value instance, value physical) {
        InstanceDevice* cast_Instance = (InstanceDevice*)val_data(instance);
        PhysicalDevice* cast_Physical = (PhysicalDevice*)val_data(physical);

        LogicalDevice* logical = new LogicalDevice(*cast_Instance, *cast_Physical);
        logical -> initDevice();

        return CFFIPointer(logical, apply_gc_logical_device);
    }
    DEFINE_PRIME2(spoopy_create_logical_device);

    value spoopy_create_surface(value instance_handle, value physical_handle, value logical_handle, value window_handle) {
        InstanceDevice* instance = (InstanceDevice*)val_data(instance_handle);
        PhysicalDevice* physical = (PhysicalDevice*)val_data(physical_handle);
        LogicalDevice* logical = (LogicalDevice*)val_data(logical_handle);
        SpoopyWindow* window = (SpoopyWindow*)val_data(window_handle);

        SurfaceDevice* surface = new SurfaceDevice(*instance, *physical, *logical, *window);
        return CFFIPointer(surface);
    }
    DEFINE_PRIME4(spoopy_create_surface);

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

    int spoopy_window_get_x(value window) {
        SpoopyWindow* cast_Window = (SpoopyWindow*)val_data(window);
        return cast_Window -> getX();
    }
    DEFINE_PRIME1(spoopy_window_get_x);

    int spoopy_window_get_y(value window) {
        SpoopyWindow* cast_Window = (SpoopyWindow*)val_data(window);
        return cast_Window -> getY();
    }
    DEFINE_PRIME1(spoopy_window_get_y);

    int32_t spoopy_window_get_id(value window) {
        SpoopyWindow* cast_Window = (SpoopyWindow*)val_data(window);
        return (int32_t)cast_Window -> getID();
    }
    DEFINE_PRIME1(spoopy_window_get_id);

    double spoopy_window_get_scale(value window) {
        SpoopyWindow* cast_Window = (SpoopyWindow*)val_data(window);
        return cast_Window -> getScale();
    }
    DEFINE_PRIME1(spoopy_window_get_scale);

    void spoopy_window_alert(value window_handle, HxString message, HxString title) {
        SpoopyWindow* window = (SpoopyWindow*)val_data(window_handle);
        window -> alert(message.c_str(), title.c_str());
    }
    DEFINE_PRIME3v(spoopy_window_alert);

    void spoopy_window_close(value window_handle) {
        SpoopyWindow* window = (SpoopyWindow*)val_data(window_handle);
        window -> close();
    }

    void spoopy_window_focus(value window_handle) {
        SpoopyWindow* window = (SpoopyWindow*)val_data(window_handle);
        window -> focus();
    }

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
}