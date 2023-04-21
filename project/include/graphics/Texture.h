#pragma once

// Base foundation for texture objects

#include <SDL.h>
#include <spoopy.h>

#include "Sampler.h"

namespace lime {
    enum TextureType: uint32_t {
        TEXTURE_2D = 0x0DE1,
        TEXTURE_CUBE = 0x8513
    };

    enum TextureUsage: uint32_t {
        READ,
        WRITE,
        RENDER_TARGET
    };

    struct TextureDescriptor {
        TextureType textureType;
        SDL_PixelFormatEnum textureFormat;
        TextureUsage textureUsage;

        uint32_t width;
        uint32_t height;

        SamplerDescriptor samplerDescriptor;

        TextureDescriptor() {
            textureType = TEXTURE_2D;
            textureFormat = SDL_PIXELFORMAT_RGBA32;
            textureUsage = READ;

            width = 0;
            height = 0;
        }
    };

    class Texture {
        public:
            virtual void updateTextureDescriptor(TextureDescriptor& descriptor);
            virtual void updateSamplerDescriptor(SamplerDescriptor& descriptor) = 0;
        protected:
            Texture(const TextureDescriptor& descriptor);
            virtual ~Texture();

            TextureType _textureType;
            SDL_PixelFormatEnum _textureFormat;
            TextureUsage _textureUsage;

            uint8_t _bitsPerElement;

            uint32_t _width;
            uint32_t _height;
    };

    class Texture2D: public Texture {
        protected:
            Texture2D(const TextureDescriptor& descriptor);
    };
}