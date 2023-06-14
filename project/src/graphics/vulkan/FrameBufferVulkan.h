#pragma once

#include "../../helpers/SpoopyHelpersVulkan.h"

#include <math/Vector2T.h>

/*
 * Borderline pointless class, but it's here for consistency.
 */

namespace lime { namespace spoopy {
    class FrameBufferVulkan {
        public:
            FrameBufferVulkan(VkDevice device, Vector2T_u32 size, uint32_t layers, VkImageView pAttachments, VkRenderPass renderPass);
            ~FrameBufferVulkan();

            operator const VkFramebuffer &() const { return framebuffer; }

            VkFramebuffer getFramebuffer() const { return framebuffer; }
        private:
            VkDevice device;
            VkFramebuffer framebuffer;
    };
}}
