#pragma once

#include "../../../helpers/metal/SpoopyMetalHelpers.h"

#include <graphics/Texture.h>

#import <Metal/Metal.h>

namespace lime {
    class TextureMTL {
        public:
            inline id<MTLTexture> getMTLTexture() const { return _mtlTexture; }
            inline id<MTLSamplerState> getMTLSamplerState() const { return _mtlSamplerState; }
        protected:
            virtual void createTexture(id<MTLDevice> mtlDevice, TextureDescriptor& descriptor) = 0;
            virtual void createSampler(id<MTLDevice> mtlDevice, SamplerDescriptor& descriptor) = 0;

            id<MTLDevice> _mtlDevice;
            id<MTLTexture> _mtlTexture;
            id<MTLSamplerState> _mtlSamplerState;

            MTLSamplerAddressMode _sAddressMode;
            MTLSamplerAddressMode _tAddressMode;
            MTLSamplerMinMagFilter _minFilter;
            MTLSamplerMinMagFilter _magFilter;
            MTLSamplerMipFilter _mipFilter;
    };
}