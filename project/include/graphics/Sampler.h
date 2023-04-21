#pragma once

#include <system/CFFI.h>

namespace lime {
    enum SamplerFilter: uint32_t {
        NEAREST = 0x2600,
        LINEAR = 0x2601,
        NEAREST_MIPMAP_NEAREST = 0x2700,
        LINEAR_MIPMAP_NEAREST = 0x2701,
        NEAREST_MIPMAP_LINEAR = 0x2702,
        LINEAR_MIPMAP_LINEAR = 0x2703,
        NO_FILTER = 0x0
    };

    enum SamplerAddressMode: uint32_t {
        CLAMP_TO_EDGE = 0x812F,
        MIRROR_REPEAT = 0x8370,
        REPEAT = 0x2901,
        NO_MODE = 0x0
    };

    struct SamplerDescriptor {
        SamplerFilter magFilter; // LINEAR
        SamplerFilter minFilter; // LINEAR
        SamplerAddressMode sAddressMode; // CLAMP_TO_EDGE
        SamplerAddressMode tAddressMode; // CLAMP_TO_EDGE

        SamplerDescriptor() {
            magFilter = LINEAR;
            minFilter = LINEAR;
            sAddressMode = CLAMP_TO_EDGE;
            tAddressMode = CLAMP_TO_EDGE;
        }

        SamplerDescriptor(
                SamplerFilter _magFilter,
                SamplerFilter _minFilter,
                SamplerAddressMode _sAddressMode,
                SamplerAddressMode _tAddressMode
        ): magFilter(_magFilter), minFilter(_minFilter),
            sAddressMode(_sAddressMode), tAddressMode(_tAddressMode) {}

        SamplerDescriptor(value descriptor);
    };
}