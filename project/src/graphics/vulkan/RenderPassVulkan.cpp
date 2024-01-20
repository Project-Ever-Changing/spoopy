#include "RenderPassVulkan.h"
#include "GraphicsVulkan.h"
#include "../../device/LogicalDevice.h"

#include <spoopy.h>

#define MAX_COLOR_ATTACHMENTS 6

namespace lime { namespace spoopy {
    RenderPassKey::RenderPassKey(const LogicalDevice &device)
    : device(device) {
        platform::memClear(&value, sizeof(value));

    }

    RenderPassKey::~RenderPassKey() {
        vkDestroyRenderPass(device, pass, nullptr);
    }

    std::size_t RenderPassKey::GetHash(const uint16_t &start) const {
        std::size_t hash = start;

        hash_combine(hash, value.hasDepth);
        hash_combine(hash, value.hasStencil);
        hash_combine(hash, value.numColorAttachments);
        hash_combine(hash, value.MSAALevel);
        hash_combine(hash, value.colorFormat);

        return hash;
    }


    RenderPassVulkan::RenderPassVulkan(const LogicalDevice &device, const VkFormat &format, const int &msaaLevel)
    : GPUResource(device)
    , createInfo(device) {
        createInfo.value.colorFormat = format;
        createInfo.value.numColorAttachments = 1;
        createInfo.value.MSAALevel = msaaLevel;
    }

    void RenderPassVulkan::Create() {
        if(handle.Compare(&createInfo)) return;

        VkAttachmentDescription2 attachments[MAX_COLOR_ATTACHMENTS + 1];
        VkAttachmentReference2 colorReferences[MAX_COLOR_ATTACHMENTS];

        VkSubpassDescription2 subpass = {};
        platform::memClear(&subpass, sizeof(subpass));
        subpass.pipelineBindPoint = VK_PIPELINE_BIND_POINT_GRAPHICS;
        subpass.flags = 0;
        subpass.inputAttachmentCount = 0;
        subpass.pInputAttachments = nullptr;
        subpass.colorAttachmentCount = createInfo.value.numColorAttachments;
        subpass.pColorAttachments = colorReferences;

        for (int32 i=0; i<createInfo.value.numColorAttachments; i++) {
            VkAttachmentDescription2 &attachment = attachments[i];
            attachment.flags = 0;
            attachment.format = createInfo.value.colorFormat;
            attachment.samples = (VkSampleCountFlagBits)createInfo.value.MSAALevel;
            attachment.loadOp = VK_ATTACHMENT_LOAD_OP_LOAD;
            attachment.storeOp = VK_ATTACHMENT_STORE_OP_STORE;
            attachment.stencilLoadOp = VK_ATTACHMENT_LOAD_OP_DONT_CARE;
            attachment.stencilStoreOp = VK_ATTACHMENT_STORE_OP_DONT_CARE;
            attachment.initialLayout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;
            attachment.finalLayout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;

            VkAttachmentReference2 &colorReference = colorReferences[i];
            colorReference.attachment = i;
            colorReference.layout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;
        }

        if(createInfo.value.hasDepth) {
            VkImageLayout depthStencilLayout;

            VkAttachmentReference2 depthStencilReference;
            depthStencilReference.aspectMask |= VK_IMAGE_ASPECT_DEPTH_BIT;

            VkAttachmentDescription2 &depthAttachment = attachments[createInfo.value.numColorAttachments];
            depthAttachment.flags = 0;
            depthAttachment.samples = (VkSampleCountFlagBits)createInfo.value.MSAALevel;

            // TODO: If the createInfo has a depth buffer, then read and write to it (VK_ATTACHMENT_LOAD_OP_LOAD)
            // OTHERWISE: Don't read or write to it (VK_ATTACHMENT_LOAD_OP_DONT_CARE and VK_ATTACHMENT_STORE_OP_DONT_CARE)
            // ALSO: If the depth buffer doesn't need to be written then (VK_ATTACHMENT_STORE_OP_DONT_CARE)
            depthAttachment.loadOp = VK_ATTACHMENT_LOAD_OP_DONT_CARE;
            depthAttachment.storeOp = VK_ATTACHMENT_STORE_OP_DONT_CARE;

            if(device.FindInstanceExtensions("VK_KHR_separate_depth_stencil_layouts")
            && createInfo.value.hasStencil) {
                VkAttachmentDescriptionStencilLayoutKHR stencilLayoutDescription = {};
                stencilLayoutDescription.sType = VK_STRUCTURE_TYPE_ATTACHMENT_DESCRIPTION_STENCIL_LAYOUT_KHR;
                stencilLayoutDescription.stencilInitialLayout = VK_IMAGE_LAYOUT_STENCIL_ATTACHMENT_OPTIMAL_KHR;

                // I see no reason to write to stencil buffer after rendering
                stencilLayoutDescription.stencilFinalLayout = VK_IMAGE_LAYOUT_STENCIL_READ_ONLY_OPTIMAL_KHR;

                depthAttachment.stencilLoadOp = VK_ATTACHMENT_LOAD_OP_LOAD;
                depthAttachment.stencilStoreOp = VK_ATTACHMENT_STORE_OP_STORE;
                depthAttachment.pNext = &stencilLayoutDescription;

                // TODO: If the depth buffer's image view is a depth/stencil image view then use VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL
                // Determine this if the format is VK_FORMAT_D32_SFLOAT_S8_UINT or VK_FORMAT_D24_UNORM_S8_UINT
                depthStencilLayout = VK_IMAGE_LAYOUT_DEPTH_STENCIL_READ_ONLY_OPTIMAL;

                if(depthStencilLayout == VK_IMAGE_LAYOUT_STENCIL_ATTACHMENT_OPTIMAL_KHR) {
                    VkAttachmentReferenceStencilLayoutKHR stencilReferenceDescription = {};
                    stencilReferenceDescription.sType = VK_STRUCTURE_TYPE_ATTACHMENT_REFERENCE_STENCIL_LAYOUT_KHR;
                    stencilReferenceDescription.stencilLayout = VK_IMAGE_LAYOUT_STENCIL_ATTACHMENT_OPTIMAL_KHR;
                    depthStencilReference.pNext = &stencilReferenceDescription;
                }

                depthStencilReference.aspectMask |= VK_IMAGE_ASPECT_STENCIL_BIT;
            }else {
                depthAttachment.stencilLoadOp = VK_ATTACHMENT_LOAD_OP_DONT_CARE;
                depthAttachment.stencilStoreOp = VK_ATTACHMENT_STORE_OP_DONT_CARE;
                depthAttachment.pNext = nullptr;

                // TODO: If the depth buffer's image view is a depth-only image view then use VK_IMAGE_LAYOUT_DEPTH_ATTACHMENT_OPTIMAL
                // Determine this if the format is VK_FORMAT_D32_SFLOAT or VK_FORMAT_D16_UNORM
                depthStencilLayout = VK_IMAGE_LAYOUT_DEPTH_READ_ONLY_OPTIMAL;
            }

            depthStencilReference.attachment = createInfo.value.numColorAttachments;
            depthStencilReference.layout = depthStencilLayout;
            subpass.pDepthStencilAttachment = &depthStencilReference;
        }

        VkRenderPass renderPass;

        VkRenderPassCreateInfo2 renderPassInfo = {};
        renderPassInfo.sType = VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO;
        renderPassInfo.attachmentCount = createInfo.value.numColorAttachments + (createInfo.value.hasDepth ? 1 : 0);
        renderPassInfo.pAttachments = attachments;
        renderPassInfo.subpassCount = 1;
        renderPassInfo.pSubpasses = &subpass;
        checkVulkan(vkCreateRenderPass2(device, &renderPassInfo, nullptr, &renderPass));

        handle.InsertOrGet(&createInfo);
    }

    void RenderPassVulkan::Destroy() {
        handle.Clear();
    }
}}