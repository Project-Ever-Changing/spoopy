package spoopy.graphics.texture;

import spoopy.graphics.texture.sampler.SpoopySamplerInfo;

import lime.graphics.PixelFormat;

/*
 * Texture information is a collection of data that provides various details about a texture.
 *
 * No change to the `SpoopyTextureDescriptor` will take effect unless the texture class using this
 * descriptor is reallocated or allocated.
 */
class SpoopyTextureDescriptor {
    public var textureType:SpoopyTextureType;
    public var textureFormat:PixelFormat;
    public var textureUsage:SpoopyTextureUsage;

    public var samplerCreateInfo(default, null):SpoopySamplerInfo;

    public function new(
    ?textureType:SpoopyTextureType = TEXTURE_2D,
    ?textureFormat:PixelFormat = RGBA32,
    ?textureUsage:SpoopyTextureUsage = READ) {
        this.textureType = textureType;
        this.textureFormat = textureFormat;
        this.textureUsage = textureUsage;

        this.samplerCreateInfo = new SpoopySamplerInfo();
    }
}