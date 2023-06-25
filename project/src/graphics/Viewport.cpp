#include <graphics/Viewport.h>

namespace lime { namespace spoopy {
    Viewport::Viewport(const Rectangle &rect) {
        extent = {
            static_cast<uint32_t>(rect.width),
            static_cast<uint32_t>(rect.height)
        };

        offset = {
            static_cast<int32_t>(rect.x),
            static_cast<int32_t>(rect.y)
        };
    }
}}