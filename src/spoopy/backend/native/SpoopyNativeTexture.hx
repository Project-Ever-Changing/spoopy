package spoopy.backend.native;

import spoopy.graphics.other.SpoopySwapChain;
import spoopy.graphics.texture.sampler.SpoopySamplerInfo;
import spoopy.graphics.texture.SpoopyTextureDescriptor;
import spoopy.graphics.texture.SpoopyTextureUsage;
import spoopy.graphics.texture.SpoopyTextureType;

import lime.graphics.PixelFormat;

@:access(spoopy.graphics.other.SpoopySwapChain)
class SpoopyNativeTexture {
    public var handle:Dynamic;
    public var descriptor:Dynamic;

    public function new(width:Int, height:Int, device:SpoopySwapChain, textureDescriptor:SpoopyTextureDescriptor) {
        descriptor = SpoopyNativeCFFI.spoopy_create_texture_descriptor(
            width,
            height,
            textureDescriptor.textureType,
            textureDescriptor.textureFormat,
            textureDescriptor.textureUsage,
            textureDescriptor.samplerCreateInfo
        );

        if(textureDescriptor.textureType == SpoopyTextureType.TEXTURE_CUBE) {
            //TODO: Have backend cube texture creation.
        }else {
            handle = SpoopyNativeCFFI.spoopy_create_texture(
                device.__surface.device,
                descriptor
            );
        }
    }

    public function updateTexture(width:Int, height:Int, tType:SpoopyTextureType, tFormat:PixelFormat, tUsage:SpoopyTextureUsage, samplerInfo:SpoopySamplerInfo):Void {
        SpoopyNativeCFFI.spoopy_update_texture_descriptor(handle, descriptor, width, height, tType, tFormat, tUsage, samplerInfo);
    }

    public function updateSampler(samplerInfo:SpoopySamplerInfo):Void {
        SpoopyNativeCFFI.spoopy_update_sampler_descriptor(handle, samplerInfo);
    }
}