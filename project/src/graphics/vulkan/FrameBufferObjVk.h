#pragma once

#include "../FrameBufferObject.h"

#include <spoopy.h>
#include <unordered_map>
#include <memory>

namespace std {
    template<> struct hash<lime::spoopy::FrameBufferObject::Attachment> {
        std::size_t operator()(lime::spoopy::FrameBufferObject::Attachment const& attachment) const noexcept {
            return static_cast<std::size_t>(attachment);
        }
    };
}


namespace lime { namespace spoopy {
    class FrameBufferVulkan;
    class RenderPassVulkan;

    struct VkImages {
        VkImage image;
        VkImageView imageView;
    };

    class FrameBufferObjVk: public FrameBufferObject {
        public:
            FrameBufferObjVk(VkDevice device): device(device) {}
            ~FrameBufferObjVk();

            VkImageView GetAttachmentImageView(Attachment attachment) const;

        protected:
            VkDevice device;

            std::unique_ptr<FrameBufferVulkan> framebuffer;
            std::unique_ptr<RenderPassVulkan> renderPass;

            std::unordered_map<Attachment, VkImages> images;
    };
}}