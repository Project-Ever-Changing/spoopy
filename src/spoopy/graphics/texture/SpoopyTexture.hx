package spoopy.graphics.texture;

import spoopy.graphics.other.SpoopySwapChain;
import spoopy.graphics.texture.SpoopyTextureDescriptor;
import spoopy.graphics.texture.sampler.SpoopySamplerInfo;
import spoopy.backend.native.SpoopyNativeTexture;

import lime.graphics.PixelFormat;

class SpoopyTexture {

    /*
    * NOTE: Changing any of these values will not take effect until `updateTexture` is called.
    */
    public var width:Int;
    public var height:Int;

    public var textureType:SpoopyTextureType;
    public var textureFormat:PixelFormat;
    public var textureUsage:SpoopyTextureUsage;

    /*
    * NOTE: Changing any of these values will not take effect until `updateSampler` is called.
    */
    public var samplerCreateInfo(default, null):SpoopySamplerInfo;

    @:noCompletion private var __backend:SpoopyNativeTexture;

    public function new(?width:Int = 0, ?height:Int = 0, device:SpoopySwapChain, descriptor:SpoopyTextureDescriptor) {
        this.width = width;
        this.height = height;
        this.textureType = descriptor.textureType;
        this.textureFormat = descriptor.textureFormat;
        this.textureUsage = descriptor.textureUsage;
        this.samplerCreateInfo = descriptor.samplerCreateInfo;

        __backend = new SpoopyNativeTexture(width, height, device, descriptor);
    }

    public function updateTexture():Void {
        __backend.updateTexture(width, height, textureType, textureFormat, textureUsage, samplerCreateInfo);
    }

    public function updateSampler():Void {
        __backend.updateSampler(samplerCreateInfo);
    }
}