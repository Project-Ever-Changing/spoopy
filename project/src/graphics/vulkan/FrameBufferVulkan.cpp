#include "FrameBufferVulkan.h"

namespace lime { namespace spoopy {
    FrameBufferVulkan::FrameBufferVulkan(VkDevice device, Vector2T_u32 size, uint32_t layers, VkImageView pAttachments, VkRenderPass renderPass)
    : device(device) {
        VkFramebufferCreateInfo framebufferInfo = {};
        framebufferInfo.sType = VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO;
        framebufferInfo.pAttachments = &pAttachments;
        framebufferInfo.flags = 0;
        framebufferInfo.width = size.x;
        framebufferInfo.height = size.y;
        framebufferInfo.layers = layers;
        framebufferInfo.pNext = nullptr;
        framebufferInfo.renderPass = renderPass;

        checkVulkan(vkCreateFramebuffer(device, &framebufferInfo, nullptr, &framebuffer));
    }

    FrameBufferVulkan::~FrameBufferVulkan() {
        vkDestroyFramebuffer(device, framebuffer, nullptr);
    }
}}