#import "../../helpers/metal/SpoopyMetalHelpers.h"

#include <shaders/Shader.h>

namespace lime {
    class MetalShader: public Shader {
        public:
            MetalShader(value window_surface, value device);
            ~MetalShader();

            virtual void specializeShader(const char* name, const char* vertex, const char* fragment);
            virtual void cleanUp();

            virtual value createShaderPipeline();

            virtual id<MTLLibrary> createLibrary(const char* _source) const;
            virtual id<MTLRenderPipelineState> createRenderPipelineStateWithDescriptor(MTLRenderPipelineDescriptor* _descriptor) const;

            virtual void setShaderUniform(int offset, uint32_t loc, const void* val, uint32_t numRegs);
        private:
            id<MTLDevice> shader_device;

            SpoopyPipelineDescriptor pd;

            id<MTLFunction> vertexFunction;
            id<MTLFunction> fragmentFunction;
    };

    MetalShader::MetalShader(value window_surface, value device) {
        shader_device = (id<MTLDevice>)val_data(device);
        windowSurface = (SpoopyWindowSurface*)val_data(window_surface);

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

    void MetalShader::setShaderUniform(int offset, uint32_t loc, const void* val, uint32_t numRegs) {

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
        release(shader_device);
        release(vertexFunction);
        release(fragmentFunction);
        release(pd);

        MetalShader::~Shader();
    }


    Shader* createShader(value window_surface, value device) {
        return new MetalShader(window_surface, device);
    }
}