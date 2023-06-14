#include "FrameBufferVulkan.h"
#include "RenderPassVulkan.h"
#include "FrameBufferObjVk.h"

#include <core/Log.h>

namespace lime { namespace spoopy {
    FrameBufferObjVk::~FrameBufferObjVk() {
        for(auto& image: images) {
            vkDestroyImageView(device, image.second.imageView, nullptr);
            vkDestroyImage(device, image.second.image, nullptr);
        }
    }

    VkImageView FrameBufferObjVk::GetAttachmentImageView(Attachment attachment) const {
        auto it = images.find(attachment);

        if(it == images.end()) {
            SPOOPY_LOG_ERROR("Attachment ImageView not found!");
            return VK_NULL_HANDLE;
        }

        return it->second.imageView;
    }
}}