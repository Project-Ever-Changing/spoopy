#pragma once

/*
 * If I ever have plans to support other graphics APIs.
 */

namespace lime { namespace spoopy {
    enum class ShaderAPI {
        Unknown = 0,
        GLSL440 = 1,
        GLSL450 = 2,
        Vulkan = 4
    };
}}