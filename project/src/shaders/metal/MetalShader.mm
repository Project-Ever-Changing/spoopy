#include "MetalShader.h"

#include <map>

namespace lime {
    MetalShader::MetalShader(value window_surface, value device) {
        shader_device = (id<MTLDevice>)val_data(device);
        windowSurface = (SpoopyWindowRenderer*)val_data(window_surface);

        pd = [MTLRenderPipelineDescriptor new];
    }

    void MetalShader::specializeShader(const char* name, const char* vertex, const char* fragment) {
        id<MTLLibrary> library = createLibrary(vertex);

        if(library != NULL) {
            vertexFunction = [library newFunctionWithName:@(name)];
            release(library);
        }

        library = createLibrary(fragment);

        if(library != NULL) {
            fragmentFunction = [library newFunctionWithName:@(name)];
            release(library);
        }
    }

    void MetalShader::setShaderUniform(value uniform_handle, uint32_t offset, uint32_t loc, const void* val, uint32_t numRegs) {
        id<MTLBuffer> uniform_buffer = (id<MTLBuffer>)val_data(uniform_handle);
        uint8_t* dst = (uint8_t*)uniform_buffer.contents;

        memcpy(&dst[offset + loc], val, numRegs*16);
    }

    value MetalShader::createShaderPipeline() {
        UInt32 pixelFormat = SDL_GetWindowPixelFormat(windowSurface -> getWindow().sdlWindow);
        SpoopyPixelFormat mtlPixelFormat = SpoopyMetalHelpers::convertSDLtoMetal(pixelFormat);

        reset(pd);
        pd.colorAttachments[0].pixelFormat = mtlPixelFormat;
        pd.vertexFunction = vertexFunction;
        pd.fragmentFunction = fragmentFunction;

        SpoopyPipelineState ps = createRenderPipelineStateWithDescriptor(pd);
        return CFFIPointer(ps, apply_gc_render_pipeline);
    }

    id<MTLLibrary> MetalShader::createLibrary(const char* _source) const {
        NSError* error;
        id<MTLLibrary> __library = [shader_device newLibraryWithSource:@(_source) options:nil error:&error];

        if (!__library) {
            NSLog(@"Failed to create library: %@", error);
        }

        return __library;
    }

    id<MTLRenderPipelineState> MetalShader::createRenderPipelineStateWithDescriptor(MTLRenderPipelineDescriptor* _descriptor) const {
        NSError* error = nil;
        std::vector<char> infoLog(1024);

        id<MTLRenderPipelineState> state = [shader_device newRenderPipelineStateWithDescriptor:_descriptor error:&error];

        if (error) {
            NSUInteger maxLength = 1024;
            NSString* errorString = [error localizedDescription];
            [errorString getBytes:&infoLog maxLength:fmin([errorString lengthOfBytesUsingEncoding:NSUTF8StringEncoding], maxLength) usedLength:nil encoding:NSUTF8StringEncoding options:NSStringEncodingConversionAllowLossy range:NSMakeRange(0, [errorString length]) remainingRange:nil];
            NSLog(@"Shader linking failed: %@", [NSString stringWithCString:infoLog.data() encoding:NSUTF8StringEncoding]);
        }

        return state;
    }

    void MetalShader::cleanUp() {
        release(vertexFunction);
        release(fragmentFunction);
    }

    MetalShader::~MetalShader() {
        release(vertexFunction);
        release(fragmentFunction);
        release(pd);

        MetalShader::~Shader();
    }


    Shader* createShader(value window_surface, value device) {
        return new MetalShader(window_surface, device);
    }
}