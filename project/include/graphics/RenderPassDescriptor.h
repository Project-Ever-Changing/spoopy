#pragma once

#include <graphics/Texture.h>

namespace lime {
    template<class TEXTURE_2D> struct RenderPassDescriptor {
        RenderPassDescriptor() {
            clearColorValue[0] = 0.0f;
            clearColorValue[1] = 0.0f;
            clearColorValue[2] = 0.0f;
            clearColorValue[3] = 1.0f;

            for(int i=0; i<MAX_COLOR_ATTACHMENT; ++i) {
                colorAttachment[i] = nullptr;
            }

            needColorAttachment = true;
            needClearColor = false;
        }

        bool operator==(const RenderPassDescriptor& descriptor) const {
            if(clearColorValue == descriptor.clearColorValue &&
            colorAttachment[0] == descriptor.colorAttachment[0] &&
            needColorAttachment == descriptor.needColorAttachment &&
            needClearColor == descriptor.needClearColor) {
                return true;
            } else {
                return false;
            }
        }

        ~RenderPassDescriptor() {
            for(int i=0; i<MAX_COLOR_ATTACHMENT; ++i) {
                if(colorAttachment[i]) {
                    delete colorAttachment[i];
                    colorAttachment[i] = nullptr;
                }
            }
        }

        float clearColorValue[4];

        bool needColorAttachment;
        bool needClearColor;

        TEXTURE_2D* colorAttachment[MAX_COLOR_ATTACHMENT];
    };
}