#ifndef SPOOPY_DEVICES_H
#define SPOOPY_DEVICES_H

#include <vector>

namespace spoopy {
    struct Devices {
        static const std::vector<const char*> Extensions;
        static const std::vector<const char*> ValidationLayers;
    };
}
#endif