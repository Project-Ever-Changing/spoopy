#pragma once

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
         * If the device supports hardware geometry instancing.
         */
        bool HasHardwareInstancing;

        /*
         * If the device supports rendering to volume textures. (Using Geometry Shaders)
         */
        bool HasVolumeRendering;

        /*
         * If the device supports indirect drawing. (Including fragment shaders to write to Storage Images)
         */
        bool HasIndirectDrawing;

        /*
         * If the device supports append/consume buffers.
         */
        bool HasAppendConsumeBuffers;

        /*
         * If the device allows distinct blending operations for individual render targets.
         */
        bool HasSeparateRenderTargetBlendingStates;

        /*
         * If the device supports using depth buffer textures as descriptors in shaders.
         */
        bool HasDepthBufferTextures;

        /*
         * If the device supports read only depth buffer in depth buffer textures.
         */
        bool HasReadOnlyDepth;

        /*
         * If the device supports using a multi-sampled depth buffer texture as an image sampler in shaders.
         */
        bool HasMultisampleDepthAsSampler;

        /*
         * Indicates whether the device supports shader reading from typed image views (common formats such as B32G32R32A32, B16G16R16A16, R16, R8). This does not apply to single-component 32-bit formats.
         */
        bool HasTypedUAVLoad;

        /*
         * The maximum amount of texture mip levels.
         */
        uint32_t MaxTextureMipLevels;

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