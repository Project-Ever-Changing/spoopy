#include <helpers/SpoopyBufferHelper.h>

#include "SpoopyMetalHelpers.h"

namespace lime {
    bool SpoopyBufferHelper::compareTwoBuffers(value buffer1, value buffer2) {
        id<MTLBuffer> bf1 = (id<MTLBuffer>)val_data(buffer1);
        id<MTLBuffer> bf2 = (id<MTLBuffer>)val_data(buffer2);

        if((uint8_t*)bf1.contents == (uint8_t*)bf2.contents) {
            return true;
        }

        return false;
    }
}