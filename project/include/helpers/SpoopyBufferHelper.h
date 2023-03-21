#pragma once

#include <system/CFFIPointer.h>

namespace lime {
    struct SpoopyBufferHelper {
        static bool compareTwoBuffers(value buffer1, value buffer2);
    };
}