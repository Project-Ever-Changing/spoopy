#pragma once

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
}
