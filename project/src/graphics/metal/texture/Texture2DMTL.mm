#import "Texture2DMTL.h"

namespace lime {
    MTLSamplerAddressMode getMTLSamplerAddressMode(SamplerAddressMode mode) {
        MTLSamplerAddressMode ret = MTLSamplerAddressModeRepeat;
        switch (mode) {
            case REPEAT:
                ret = MTLSamplerAddressModeRepeat;
                break;
            case MIRROR_REPEAT:
                ret = MTLSamplerAddressModeMirrorRepeat;
                break;
            case CLAMP_TO_EDGE:
                ret = MTLSamplerAddressModeClampToEdge;
                break;
            default:
                printf("%s", "Not supported sampler address mode!");
                break;
        }
        return ret;
    }

    MTLSamplerMinMagFilter getMTLSamplerMinMagFilter(SamplerFilter mode) {
        switch (mode) {
            case NEAREST:
            case NEAREST_MIPMAP_LINEAR:
            case NEAREST_MIPMAP_NEAREST:
                return MTLSamplerMinMagFilterNearest;
            case LINEAR:
            case LINEAR_MIPMAP_LINEAR:
            case LINEAR_MIPMAP_NEAREST:
                return MTLSamplerMinMagFilterLinear;
            default:
                return MTLSamplerMinMagFilterNearest;
        }
    }

    Texture2DMTL::Texture2DMTL(id<MTLDevice> mtlDevice, TextureDescriptor& descriptor): Texture2D(descriptor) {
        _mtlDevice = mtlDevice;
        _bytesPerRow = 0;

        updateTextureDescriptor(descriptor);
    }

    void Texture2DMTL::updateTextureDescriptor(TextureDescriptor& descriptor) {
        Texture2D::updateTextureDescriptor(descriptor);
        createTexture(_mtlDevice, descriptor);
        updateSamplerDescriptor(descriptor.samplerDescriptor);

        if(_textureFormat == SDL_PIXELFORMAT_RGB888) {
            _bitsPerElement = 4 * 8;
        }

        _bytesPerRow = descriptor.width * _bitsPerElement / 8;
    }

    void Texture2DMTL::updateSamplerDescriptor(SamplerDescriptor& descriptor) {
        createSampler(_mtlDevice, descriptor);
    }

    void Texture2DMTL::createTexture(id<MTLDevice> mtlDevice, TextureDescriptor& descriptor) {
        MTLPixelFormat _mtlPixelFormat = SpoopyMetalHelpers::convertSDLtoMetal(descriptor.textureFormat);

        if(_mtlPixelFormat == MTLPixelFormatInvalid) {
            return;
        }

        MTLTextureDescriptor* _mtlTextureDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:_mtlPixelFormat width:descriptor.width height:descriptor.height mipmapped:YES];

        if(descriptor.textureUsage == RENDER_TARGET) {
            _mtlTextureDescriptor.usage = MTLTextureUsageRenderTarget | MTLTextureUsageShaderRead;
        }

        if(_mtlTexture) {
            release(_mtlTexture);
        }

        _mtlTexture = [mtlDevice newTextureWithDescriptor:_mtlTextureDescriptor];
    }

    void Texture2DMTL::createSampler(id<MTLDevice> mtlDevice, SamplerDescriptor& descriptor) {
        MTLSamplerDescriptor* _mtlDescriptor = [MTLSamplerDescriptor new];
        _mtlDescriptor.sAddressMode = descriptor.sAddressMode == NO_MODE ? _sAddressMode : getMTLSamplerAddressMode(descriptor.sAddressMode);
        _mtlDescriptor.tAddressMode = descriptor.tAddressMode == NO_MODE ? _tAddressMode : getMTLSamplerAddressMode(descriptor.tAddressMode);
        _mtlDescriptor.minFilter = descriptor.minFilter == NO_FILTER ? _minFilter : getMTLSamplerMinMagFilter(descriptor.minFilter);
        _mtlDescriptor.magFilter = descriptor.magFilter == NO_FILTER ? _magFilter : getMTLSamplerMinMagFilter(descriptor.magFilter);

        if(_mtlSamplerState) {
            release(_mtlSamplerState);
            _mtlSamplerState = nil;
        }

        _sAddressMode = _mtlDescriptor.sAddressMode;
        _tAddressMode = _mtlDescriptor.tAddressMode;
        _minFilter = _mtlDescriptor.minFilter;
        _magFilter = _mtlDescriptor.magFilter;
        _mipFilter = _mtlDescriptor.mipFilter;

        _mtlSamplerState = [mtlDevice newSamplerStateWithDescriptor:_mtlDescriptor];
        release(_mtlDescriptor);
    }

    Texture2DMTL::~Texture2DMTL() {
        release(_mtlTexture);
        release(_mtlSamplerState);

        _mtlDevice = nil;
    }


    Texture2D* createTexture2D(value device, TextureDescriptor& descriptor) {
        id<MTLDevice> _mtlDevice = (id<MTLDevice>)val_data(device);
        return new Texture2DMTL(_mtlDevice, descriptor);
    }
}