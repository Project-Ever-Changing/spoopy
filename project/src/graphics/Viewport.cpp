#include <graphics/Viewport.h>

namespace lime { namespace spoopy {
    Viewport::Viewport() {
        extent = {0, 0};
        offset = {0, 0};
    }

    Viewport::Viewport(value rect) {
        SetTo(Rectangle(rect));
    }

    Viewport::Viewport(const Rectangle &rect) {
        SetTo(rect);
    }

    void Viewport::SetTo(const Rectangle &rect) {
        extent = {
            static_cast<uint32_t>(rect.width),
            static_cast<uint32_t>(rect.height)
        };

        offset = {
            static_cast<int32_t>(rect.x),
            static_cast<int32_t>(rect.y)
        };
    }

    void Viewport::SetTo(const Viewport &viewport) {
        extent = viewport.extent;
        offset = viewport.offset;
    }
}}