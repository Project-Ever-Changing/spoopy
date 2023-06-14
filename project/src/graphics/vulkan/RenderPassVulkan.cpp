#include "RenderPassVulkan.h"

namespace lime { namespace spoopy {
    VkFormat RenderPassVulkan::GetFormat(uint32_t format) {
        #ifdef SPOOPY_SDL

        switch (format) {
            case SDL_PIXELFORMAT_RGBA8888:
                return VK_FORMAT_R8G8B8A8_UNORM;
            case SDL_PIXELFORMAT_ARGB8888:
                return VK_FORMAT_A8B8G8R8_UNORM_PACK32;
            case SDL_PIXELFORMAT_BGRA8888:
                return VK_FORMAT_B8G8R8A8_UNORM;

            // These cases aren't going to be ever used, but incase that Lime updates
            // there backend to support these formats, I'll keep them here.
            case SDL_PIXELFORMAT_RGB332:
                return VK_FORMAT_R8G8B8_UNORM;
            case SDL_PIXELFORMAT_RGB444:
                return VK_FORMAT_R4G4B4A4_UNORM_PACK16;
            case SDL_PIXELFORMAT_RGB555:
                return VK_FORMAT_R5G5B5A1_UNORM_PACK16;
            case SDL_PIXELFORMAT_RGB565:
                return VK_FORMAT_R5G6B5_UNORM_PACK16;
            case SDL_PIXELFORMAT_RGB888:
                return VK_FORMAT_R8G8B8_UNORM;
            default:
                throw std::runtime_error("Unsupported SDL pixel format!");
        }

        #else

        return format;

        #endif
    }

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
        VkSampleCountFlagBits samples, VkImageLayout finalLayout, VkImageLayout initialLayout) {
        AddAttachment(format, samples, finalLayout, initialLayout);

        depthReference.attachment = location;
        depthReference.layout = layout;
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
        VkImageLayout finalLayout, VkImageLayout initialLayout) {
        VkAttachmentDescription attachmentDescription = {};
        attachmentDescription.format = GetFormat(format);
        attachmentDescription.samples = samples;
        attachmentDescription.loadOp = VK_ATTACHMENT_LOAD_OP_CLEAR;
        attachmentDescription.storeOp = VK_ATTACHMENT_STORE_OP_STORE;
        attachmentDescription.stencilLoadOp = VK_ATTACHMENT_LOAD_OP_DONT_CARE;
        attachmentDescription.stencilStoreOp = VK_ATTACHMENT_STORE_OP_DONT_CARE;
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