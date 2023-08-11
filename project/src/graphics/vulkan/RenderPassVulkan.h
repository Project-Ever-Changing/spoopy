#pragma once

#include "../../helpers/SpoopyHelpersVulkan.h"

#include <vector>

#ifdef SPOOPY_SDL
#include <SDL.h>
#endif

namespace lime { namespace spoopy {
    class RenderPassVulkan {
        public:
            RenderPassVulkan(VkDevice device): device(device) {};
            ~RenderPassVulkan();

            void CreateRenderPass();
            void CreateSubpass();

            void AddDepthAttachment(uint32_t location, VkImageLayout layout, uint32_t format,
                VkSampleCountFlagBits samples, VkImageLayout finalLayout = VK_IMAGE_LAYOUT_GENERAL,
                VkImageLayout initialLayout = VK_IMAGE_LAYOUT_UNDEFINED, bool hasStencil = false);
            void AddColorAttachment(uint32_t location, VkImageLayout layout, uint32_t format,
                VkSampleCountFlagBits samples, VkImageLayout finalLayout = VK_IMAGE_LAYOUT_GENERAL,
                VkImageLayout initialLayout = VK_IMAGE_LAYOUT_UNDEFINED);
            void AddSubpassDependency(uint32_t srcSubpass, uint32_t dstSubpass, VkPipelineStageFlags srcStageMask,
                VkPipelineStageFlags dstStageMask, VkAccessFlags srcAccessMask, VkAccessFlags dstAccessMask,
                VkDependencyFlags dependencyFlags = 0);


            operator const VkRenderPass &() const { return renderpass; }
            const VkRenderPass &GetRenderpass() const { return renderpass; }

            const uint32_t GetColorAttachmentCount() const { return colorAttachmentCount; }
            const uint32_t GetDepthAttachmentCount() const { return depthAttachmentCount; }
            const bool HasDepthAttachment() const { return attachmentDescriptions.size() > 0; }
            const VkAttachmentDescription &GetAttachmentDescriptions() const { return attachmentDescriptions.front(); }

        private:
            void AddAttachment(uint32_t format, VkSampleCountFlagBits samples,
                VkImageLayout finalLayout, VkImageLayout initialLayout, bool hasStencil = false);

            VkDevice device;
            VkAttachmentReference depthReference;
            std::vector<VkAttachmentReference> colorReferences;
            std::vector<VkAttachmentDescription> attachmentDescriptions;
            std::vector<VkAttachmentDescription> depthAttachmentsDescriptions;
            std::vector<VkSubpassDependency> subpassDependencies;
            std::vector<VkSubpassDescription> subpassDescriptions;

            VkRenderPass renderpass = VK_NULL_HANDLE;
            uint32_t colorAttachmentCount = 0;
    };
}}