#pragma once

#include <vector>

namespace lime {
    struct Devices {
        static const std::vector<const char*> Extensions;
        static const std::vector<const char*> ValidationLayers;
    };
}