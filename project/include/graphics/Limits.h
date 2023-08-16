#pragma once

#include <cstdint>

/*
 * Graphics/Logical Device limits for Vulkan or any other graphic APIs in the future.
 */

namespace lime { namespace spoopy {
    struct Limits {

        /*
         * If the device supports compute shaders.
         */
        bool HasComputeShaders;

        /*
         * If the device supports geometry shaders.
         */
        bool HasGeometryShaders;

        /*
         * If the device supports tessellation shaders.
         */
        bool HasTessellationShaders;

        /*
         * If the device supports indirect drawing. (Including fragment shaders to write to Storage Images)
         */
        bool HasIndirectDrawing;

        /*
         * If the device supports using a multi-sampled depth buffer texture as an image sampler in shaders.
         */
        bool HasMultisampleDepthAsSampler;

        /*
         * The maximum size of the 1D texture.
         */
        uint32_t MaxTexture1DSize;

        /*
         * The maximum size of 1D textures array.
         */
        uint32_t MaxTexture1DArraySize;

        /*
         * The maximum size of the 2D textures.
         */
        uint32_t MaxTexture2DSize;

        /*
         * The maximum size of 2D textures array.
         */
        uint32_t MaxTexture2DArraySize;

        /*
         * The maximum size of the 3D texture.
         */
        uint32_t MaxTexture3DSize;

        /*
         * The maximum size of the cube texture. (both width and height)
         */
        uint32_t MaxTextureCubeSize;

        /*
         * The maximum degree of anisotropic filtering used for texture sampling.
         */
        uint32_t MaxAnisotropy;
    };
}}