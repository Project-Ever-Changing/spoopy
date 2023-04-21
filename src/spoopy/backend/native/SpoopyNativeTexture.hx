package spoopy.backend.native;

import spoopy.graphics.other.SpoopySwapChain;
import spoopy.graphics.texture.SpoopyTextureDescriptor;

import lime.graphics.PixelFormat;

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

        
    }
}