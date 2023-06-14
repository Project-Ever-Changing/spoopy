#pragma once

#include <math/Vector2T.h>

namespace lime { namespace spoopy {
    class FrameBufferObject {
        public:
            enum class Attachment {
                COLOR,
                ALPHA,
                NORMAL,
                DEPTH
            };

        protected:
            Vector2T_u32 size;
            uint32_t colorAttachmentCount;
            uint32_t depthAttachment;
    };
}}