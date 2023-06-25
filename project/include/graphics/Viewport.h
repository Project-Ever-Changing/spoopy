#pragma once

#include <math/Vector2T.h>
#include <math/Rectangle.h>

namespace lime { namespace spoopy {
    struct Viewport {
        Viewport(const Rectangle &rect);

        Vector2T_u32 extent;
        Vector2T_32 offset;
    };
}}