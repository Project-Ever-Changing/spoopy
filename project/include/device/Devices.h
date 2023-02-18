#pragma once

#include <vector>

namespace lime {
    struct Devices {
        #ifdef SPOOPY_VULKAN
        static const std::vector<const char*> Extensions;
        static const std::vector<const char*> ValidationLayers;
        #endif
    };
}