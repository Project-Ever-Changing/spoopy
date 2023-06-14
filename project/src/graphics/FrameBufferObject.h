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
            Vector2T_u32 size = {0, 0};
            uint32_t colorAttachmentCount = 0;
            uint32_t depthAttachment = 0;
    };
}}