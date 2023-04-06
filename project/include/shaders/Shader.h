#pragma once

#include <system/CFFIPointer.h>
#include <helpers/SpoopyRenderTypes.h>
#include <ui/SpoopyWindowRenderer.h>

namespace lime {
    class Shader {
        public:
            virtual ~Shader() {
                if(windowSurface != nullptr) {
                    delete windowSurface;
                }
            };

            virtual void specializeShader(const char* name, const char* vertex, const char* fragment) = 0;
            virtual void cleanUp() = 0;

            #ifdef SPOOPY_METAL
            virtual void setShaderUniform(value uniform_handle, uint32_t offset, uint32_t loc, const void* val, uint32_t numRegs) = 0;
            #endif

            virtual value createShaderPipeline() = 0;
        public:
            SpoopyWindowRenderer* windowSurface;
    };

    Shader* createShader(value window_surface, value device);
}