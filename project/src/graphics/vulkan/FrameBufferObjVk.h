#pragma once

#include "../FrameBufferObject.h"

#include <spoopy.h>

namespace lime { namespace spoopy {
    class FrameBufferObjVk: public FrameBufferObject {
        public:
            ~FrameBufferObjVk();

            protexted:
                VkFramebuffer framebuffer;

    };
}}