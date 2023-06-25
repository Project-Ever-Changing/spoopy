#include "FrameBufferVulkan.h"

namespace lime { namespace spoopy {
    FrameBufferVulkan::FrameBufferVulkan(VkDevice device, Vector2T_u32 extent, uint32_t layers, std::vector<VkImageView> pAttachments, VkRenderPass renderPass)
    : device(device) {
        VkFramebufferCreateInfo framebufferInfo = {};
        framebufferInfo.sType = VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO;
        framebufferInfo.attachmentCount = static_cast<uint32_t>(pAttachments.size());
        framebufferInfo.pAttachments = pAttachments.data();
        framebufferInfo.flags = 0;
        framebufferInfo.width = extent.x;
        framebufferInfo.height = extent.y;
        framebufferInfo.layers = layers;
        framebufferInfo.pNext = nullptr;
        framebufferInfo.renderPass = renderPass;

        checkVulkan(vkCreateFramebuffer(device, &framebufferInfo, nullptr, &framebuffer));
    }

    FrameBufferVulkan::~FrameBufferVulkan() {
        vkDestroyFramebuffer(device, framebuffer, nullptr);
    }
}}