#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif

#include <hx/CFFI.h>
#include <hx/CFFIPrime.h>

#include <iostream>

namespace spoopy {
    void spoopy_application_init() {
        std::cout << "hehe worked" << std::endl;
    }
    DEFINE_PRIM(spoopy_application_init, 0);
}