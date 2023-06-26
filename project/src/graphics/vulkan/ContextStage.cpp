#include "framebuffers/SCFrameBuffers.h"
#include "images/ImageDepth.h"
#include "GraphicsVulkan.h"
#include "RenderPassVulkan.h"
#include "ContextVulkan.h"
#include "ContextStage.h"

namespace lime { namespace spoopy {
    ContextStage::ContextStage(const ContextVulkan &context, const Viewport &viewport):
        context(context),
        viewport(viewport) {
        // Empty for now.
    }

    ContextStage::~ContextStage() {

    }

    void ContextStage::Update() {
        auto prevRenderArea = renderArea;

        renderArea.SetOffset(viewport.offset);
        renderArea.SetExtent(viewport.extent);

        renderArea.UpdateAspectRatio();
        renderArea.SetExtent(renderArea.GetExtent() + renderArea.GetOffset());

        isDirty = prevRenderArea != renderArea;
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

        if(renderPass.HasDepthAttachment()) {
            depthImage = std::unique_ptr<ImageDepth>(new ImageDepth(*physicalDevice, *logicalDevice, renderArea.GetExtent(), samples));
        }

        //frameBuffers = std::unique_ptr<SCFrameBuffers>(new SCFrameBuffers(*logicalDevice, *swapchain, renderPass, depthImage.get(), renderArea.GetExtent()));
        isDirty = false;
    }
}}