#include <graphics/Texture.h>
#include <helpers/SpoopyBytes.h>

namespace lime {
    Texture::Texture(const TextureDescriptor& descriptor):
            _bitsPerElement(SpoopyBytes::bitsOfFormat(descriptor.textureFormat))
            , _width(descriptor.width)
            , _height(descriptor.height)
            , _textureType(descriptor.textureType)
            , _textureFormat(descriptor.textureFormat)
            , _textureUsage(descriptor.textureUsage) {}

    void Texture::updateTextureDescriptor(TextureDescriptor& descriptor) {
        _bitsPerElement = SpoopyBytes::bitsOfFormat(descriptor.textureFormat);
        _width = descriptor.width;
        _height = descriptor.height;
        _textureType = descriptor.textureType;
        _textureFormat = descriptor.textureFormat;
        _textureUsage = descriptor.textureUsage;
    }

    Texture::~Texture() {}


    Texture2D::Texture2D(const TextureDescriptor& descriptor): Texture(descriptor) {}
}
