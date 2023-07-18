#pragma once

#include <math/Vector2T.h>
#include <math/Rectangle.h>

namespace lime { namespace spoopy {
    struct Viewport {
        Viewport();
        Viewport(value rect);
        Viewport(const Rectangle &rect);

        void SetTo(const Rectangle &rect);
        void SetTo(const Viewport &viewport);

        Vector2T_u32 extent;
        Vector2T_32 offset;
    };
}}