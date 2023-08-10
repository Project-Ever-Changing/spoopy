#include "framebuffers/SCFrameBuffers.h"
#include "images/ImageDepth.h"
#include "GraphicsVulkan.h"
#include "RenderPassVulkan.h"
#include "../../../include/graphics/Context.h"
#include "ContextStage.h"

namespace lime { namespace spoopy {
    ContextStage::ContextStage(const ContextVulkan &context, const Viewport &viewport):
        context(context),
        viewport(viewport),
        isDirty(true) {
        // Empty for now.
    }

    ContextStage::~ContextStage() {

    }

    void ContextStage::SetViewport(const Viewport &viewport) {
        if(this->viewport.offset != viewport.offset || this->viewport.extent != viewport.extent) {
            this->viewport.SetTo(viewport);
            isDirty = true;
        }
    }

    void ContextStage::UpdateViewport(const VkCommandBuffer &commandBuffer) {
        VkViewport vkViewport = {};
        vkViewport.x = static_cast<float>(viewport.offset.x);
        vkViewport.y = static_cast<float>(viewport.offset.y);
        vkViewport.width = static_cast<float>(viewport.extent.x);
        vkViewport.height = static_cast<float>(viewport.extent.y);
        vkViewport.minDepth = 0.0f;
        vkViewport.maxDepth = 1.0f;
        vkCmdSetViewport(commandBuffer, 0, 1, &vkViewport);
    }

    void ContextStage::Update() {
        renderArea.SetOffset(viewport.offset);
        renderArea.SetExtent(viewport.extent);

        renderArea.UpdateAspectRatio();
        renderArea.SetExtent(renderArea.GetExtent() + renderArea.GetOffset());
    }

    void ContextStage::Build(const RenderPassVulkan &renderPass) {
        Update();

        auto physicalDevice = GraphicsVulkan::GetCurrent()->GetPhysicalDevice();
        auto logicalDevice = GraphicsVulkan::GetCurrent()->GetLogicalDevice();
        auto surface = context.GetSurface();
        auto swapchain = context.GetSwapchain();

        VkSampleCountFlagBits samples = GraphicsVulkan::GetCurrent()->MultisamplingEnabled
            ? physicalDevice->GetMaxUsableSampleCount()
            : VK_SAMPLE_COUNT_1_BIT;

        SPOOPY_LOG_INFO(std::to_string(samples));

        if(renderPass.HasDepthAttachment()) {
            depthImage = std::make_unique<ImageDepth>(*physicalDevice, *logicalDevice, renderArea.GetExtent(), samples);
        }

        frameBuffers = std::make_unique<SCFrameBuffers>(*logicalDevice, *swapchain, renderPass, depthImage.get(), renderArea.GetExtent());
        isDirty = false;
    }

    const VkFramebuffer &ContextStage::GetActiveFramebuffer(uint32_t activeSwapchainImage) const {
        if(activeSwapchainImage > frameBuffers->GetFrameBufferCount()) {
            return frameBuffers->GetFrameBuffer(0);
        }

        return frameBuffers->GetFrameBuffer(activeSwapchainImage);
    }
}}