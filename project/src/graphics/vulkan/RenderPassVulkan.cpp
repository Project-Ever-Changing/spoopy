#include "RenderPassVulkan.h"

namespace lime { namespace spoopy {
    RenderPassVulkan::~RenderPassVulkan() {
        vkDestroyRenderPass(device, renderpass, nullptr);
    }

    void RenderPassVulkan::CreateRenderPass() {
        VkRenderPassCreateInfo renderPassInfo = {};
        renderPassInfo.sType = VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO;
        renderPassInfo.pNext = nullptr;
        renderPassInfo.pAttachments = attachmentDescriptions.data();
        renderPassInfo.attachmentCount = static_cast<uint32_t>(attachmentDescriptions.size());
        renderPassInfo.pSubpasses = subpassDescriptions.data();
        renderPassInfo.subpassCount = static_cast<uint32_t>(subpassDescriptions.size());
        renderPassInfo.pDependencies = subpassDependencies.data();
        renderPassInfo.dependencyCount = static_cast<uint32_t>(subpassDependencies.size());

        checkVulkan(vkCreateRenderPass(device, &renderPassInfo, nullptr, &renderpass));
    }

    void RenderPassVulkan::CreateSubpass() {
        VkSubpassDescription subpass = {};
        subpass.pipelineBindPoint = VK_PIPELINE_BIND_POINT_GRAPHICS;
        subpass.flags = 0;
        subpass.inputAttachmentCount = 0;
        subpass.pInputAttachments = nullptr;
        subpass.colorAttachmentCount = static_cast<uint32_t>(colorReferences.size());
        subpass.pColorAttachments = colorReferences.data();
        subpass.pResolveAttachments = nullptr;
        subpass.pDepthStencilAttachment = &depthReference;
        subpass.preserveAttachmentCount = 0;
        subpass.pPreserveAttachments = nullptr;

        colorReferences.clear();
        subpassDescriptions.push_back(subpass);
    }

    void RenderPassVulkan::AddDepthAttachment(uint32_t location, VkImageLayout layout, uint32_t format,
        VkSampleCountFlagBits samples, VkImageLayout finalLayout, VkImageLayout initialLayout, bool hasStencil) {
        AddAttachment(format, samples, finalLayout, initialLayout, hasStencil);

        depthReference.attachment = location;
        depthReference.layout = layout;

        depthAttachmentCount++;
    }

    void RenderPassVulkan::AddColorAttachment(uint32_t location, VkImageLayout layout, uint32_t format,
        VkSampleCountFlagBits samples, VkImageLayout finalLayout, VkImageLayout initialLayout) {
        AddAttachment(format, samples, finalLayout, initialLayout);

        VkAttachmentReference colorReference = {};
        colorReference.attachment = location;
        colorReference.layout = layout;

        colorReferences.push_back(colorReference);
    }

    void RenderPassVulkan::AddAttachment(uint32_t format, VkSampleCountFlagBits samples,
        VkImageLayout finalLayout, VkImageLayout initialLayout, bool hasStencil) {
        VkAttachmentDescription attachmentDescription = {};
        attachmentDescription.format = static_cast<VkFormat>(format);
        attachmentDescription.samples = samples;
        attachmentDescription.loadOp = VK_ATTACHMENT_LOAD_OP_CLEAR;
        attachmentDescription.storeOp = VK_ATTACHMENT_STORE_OP_STORE;
        attachmentDescription.stencilLoadOp = hasStencil ? VK_ATTACHMENT_LOAD_OP_CLEAR : VK_ATTACHMENT_LOAD_OP_DONT_CARE;
        attachmentDescription.stencilStoreOp = hasStencil ? VK_ATTACHMENT_STORE_OP_STORE : VK_ATTACHMENT_STORE_OP_DONT_CARE;
        attachmentDescription.initialLayout = initialLayout;
        attachmentDescription.finalLayout = finalLayout;

        attachmentDescriptions.push_back(attachmentDescription);
    }

    void RenderPassVulkan::AddSubpassDependency(uint32_t srcSubpass, uint32_t dstSubpass, VkPipelineStageFlags srcStageMask,
        VkPipelineStageFlags dstStageMask, VkAccessFlags srcAccessMask, VkAccessFlags dstAccessMask,
        VkDependencyFlags dependencyFlags) {
        VkSubpassDependency subpassDependency = {};
        subpassDependency.srcSubpass = srcSubpass;
        subpassDependency.dstSubpass = dstSubpass;
        subpassDependency.srcStageMask = srcStageMask;
        subpassDependency.dstStageMask = dstStageMask;
        subpassDependency.srcAccessMask = srcAccessMask;
        subpassDependency.dstAccessMask = dstAccessMask;
        subpassDependency.dependencyFlags = dependencyFlags;

        subpassDependencies.push_back(subpassDependency);
    }
}}