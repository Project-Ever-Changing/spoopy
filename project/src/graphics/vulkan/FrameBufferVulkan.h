#pragma once

#include "../../helpers/SpoopyHelpersVulkan.h"

#include <math/Vector2T.h>

#include <vector>

/*
 * Borderline pointless class, but it's here for consistency.
 * Also, I got lazy and didn't want to put all the parameters as constant.
 */

namespace lime { namespace spoopy {
    class FrameBufferVulkan {
        public:
            explicit FrameBufferVulkan(VkDevice device, Vector2T_u32 extent, uint32_t layers, std::vector<VkImageView> pAttachments,
                VkRenderPass renderPass);
            ~FrameBufferVulkan();

            operator const VkFramebuffer &() const { return framebuffer; }

            VkFramebuffer getFramebuffer() const { return framebuffer; }
        private:
            VkDevice device;
            VkFramebuffer framebuffer;
    };
}}
