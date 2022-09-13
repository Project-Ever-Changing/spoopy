#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif

#include <iostream>

#include <hx/CFFI.h>
#include <hx/CFFIPrime.h>
#include <device/WindowDevice.h>

namespace spoopy {
    /*
    * A useless method. (for now)
    */
    void spoopy_application_init() {
        
    }
    DEFINE_PRIME0v(spoopy_application_init);

    void spoopy_window_render(value window) {
        WindowDevice* targetWindow = (WindowDevice*)val_data(window);
    }
    DEFINE_PRIME1v(spoopy_window_render);
}