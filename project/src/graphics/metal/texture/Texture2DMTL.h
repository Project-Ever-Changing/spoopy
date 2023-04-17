#pragma once

#import "TextureMTL.h"

namespace lime {
    class Texture2DMTL: public Texture2D, public TextureMTL {
        public:
            Texture2DMTL(id<MTLDevice> mtlDevice, TextureDescriptor& descriptor);
            ~Texture2DMTL();

            virtual void updateTextureDescriptor(TextureDescriptor& descriptor);
            virtual void updateSamplerDescriptor(SamplerDescriptor& descriptor);

            virtual void createTexture(id<MTLDevice> mtlDevice, TextureDescriptor& descriptor);
            virtual void createSampler(id<MTLDevice> mtlDevice, SamplerDescriptor& descriptor);
        private:
            std::size_t _bytesPerRow;
    };
}