#pragma once

#include <system/CFFIPointer.h>
#include <ui/SpoopyWindowSurface.h>

namespace lime {
    class Shader {
        public:
            virtual ~Shader() {
                if(windowSurface != nullptr) {
                    delete windowSurface;
                }
            };

            virtual void applyShaders(const char* name, const char* vertex, const char* fragment) = 0;
        public:
            SpoopyWindowSurface* windowSurface;
    };

    Shader* createShader(value window_surface, value device);
}