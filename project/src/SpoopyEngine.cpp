#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif

#include <hx/CFFI.h>
#include <hx/CFFIPrime.h>

#ifdef SPOOPY_METAL
#include <Foundation/Foundation.hpp>
#include <Metal/Metal.hpp>
#include <Metal/shared_ptr.hpp>
#include <QuartzCore/QuartzCore.hpp>
#endif

#include <iostream>

namespace spoopy {
    void spoopy_application_init() {
        std::cout << "hehe worked" << std::endl;
    }
    DEFINE_PRIME0v(spoopy_application_init);
}