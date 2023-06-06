#pragma once

#include <system/CFFIPointer.h>

namespace lime { namespace spoopy {
    struct SpoopyBufferHelper {
        static bool compareTwoBuffers(value buffer1, value buffer2);
    };
}}