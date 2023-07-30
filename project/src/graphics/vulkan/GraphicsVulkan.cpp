#include "RenderPassVulkan.h"
#include "CommandBufferVulkan.h"
#include "SwapchainVulkan.h"
#include "ContextStage.h"
#include "GraphicsVulkan.h"

#include <graphics/Context.h>

namespace lime { namespace spoopy {
    std::unique_ptr<GraphicsVulkan> GraphicsVulkan::Main = nullptr;
    bool GraphicsVulkan::MultisamplingEnabled = true;


    GraphicsVulkan::GraphicsVulkan(SDL_Window* m_window):
        instance(std::make_unique<Instance>(m_window)),
        physicalDevice(std::make_unique<PhysicalDevice>(*instance)),
        logicalDevice(std::make_unique<LogicalDevice>(*instance, *physicalDevice)),
        contexts(std::vector<std::shared_ptr<ContextVulkan>>()) {

        VkPipelineCacheCreateInfo pipelineCacheCreateInfo = {};
        pipelineCacheCreateInfo.sType = VK_STRUCTURE_TYPE_PIPELINE_CACHE_CREATE_INFO;
        checkVulkan(vkCreatePipelineCache(*logicalDevice, &pipelineCacheCreateInfo, nullptr, &pipelineCache));

        int width, height;
        SDL_GetWindowSize(m_window, &width, &height);
        displayExtent = {static_cast<uint32_t>(width), static_cast<uint32_t>(height)};
    }

    void GraphicsVulkan::Reset(const RenderPassVulkan &renderPass) {
        RecreateSwapchains();

        for(auto &context: contexts) {
            auto perSurfaceBuffer = context->GetSurfaceBuffer();

            if(perSurfaceBuffer->flightFences.size() != context->GetImageCount()) {
                context->RecreateCommandBuffers(*logicalDevice);
            }

            context->stage->Build(renderPass);
        }
    }

    void GraphicsVulkan::RecreateSwapchain(const SDL_Context &context) {
        checkVulkan(vkDeviceWaitIdle(*logicalDevice));
        context->RecreateSwapchain(*physicalDevice, *logicalDevice, displayExtent, context->GetSwapchain());
    }

    void GraphicsVulkan::RecreateSwapchains() {
        checkVulkan(vkDeviceWaitIdle(*logicalDevice));

        for(auto &context: contexts) {
            context->RecreateSwapchain(*physicalDevice, *logicalDevice, displayExtent, context->GetSwapchain());
        }
    }

    GraphicsVulkan::~GraphicsVulkan() {
        auto graphicsQueue = logicalDevice->GetGraphicsQueue();
        checkVulkan(vkQueueWaitIdle(graphicsQueue));

        for(auto &context: contexts) {
            context->DestroySwapchain();
        }

        vkDestroyPipelineCache(*logicalDevice, pipelineCache, nullptr);

        for(auto &context: contexts) {
            auto perSurfaceBuffer = context->GetSurfaceBuffer();

            for(std::size_t i=0; i<perSurfaceBuffer->flightFences.size(); ++i) {
                vkDestroyFence(*logicalDevice, perSurfaceBuffer->flightFences[i], nullptr);
                vkDestroySemaphore(*logicalDevice, perSurfaceBuffer->renderCompletes[i], nullptr);
                vkDestroySemaphore(*logicalDevice, perSurfaceBuffer->presentCompletes[i], nullptr);
            }

            perSurfaceBuffer->commandBuffers.clear();
        }

        contexts.clear();
    }

    void GraphicsVulkan::ResetPresent(const SDL_Context &context, const RenderPassVulkan &renderPass) {
        const auto &graphicsQueue = logicalDevice->GetGraphicsQueue();
        const auto &perSurfaceBuffer = context->GetSurfaceBuffer();
        const auto &swapchain = context->GetSwapchain();

        checkVulkan(vkQueueWaitIdle(graphicsQueue));

        if(perSurfaceBuffer->framebufferResized || !swapchain->IsSameExtent(displayExtent)) {
            RecreateSwapchain(context);
        }

        context->stage->Build(renderPass);
    }

    void GraphicsVulkan::AcquireNextImage(const SDL_Context &context) {
        auto perSurfaceBuffer = context->GetSurfaceBuffer();
        auto acquireResult = context->AcquireNextImage(perSurfaceBuffer->presentCompletes[perSurfaceBuffer->currentFrame], perSurfaceBuffer->flightFences[perSurfaceBuffer->currentFrame]);


        if(acquireResult == VK_ERROR_OUT_OF_DATE_KHR) {
            RecreateSwapchain(context);
            return;
        }

        if(acquireResult != VK_SUCCESS && acquireResult != VK_SUBOPTIMAL_KHR) {
            SPOOPY_LOG_ERROR("Failed to acquire next image!");
            return;
        }
    }

    void GraphicsVulkan::Record(const SDL_Context &context, const RenderPassVulkan &renderPass) {
        /*
        auto &stage = context->stage;
        bool dirty = false;

        if(stage->IsDirty()) {
            ResetPresent(context, renderPass);
            dirty = true;
        }


        // Begin Render Pass

        const auto &swapchain = context->GetSwapchain();
        const auto &perSurfaceBuffer = context->GetSurfaceBuffer();
        auto &commandBuffer = perSurfaceBuffer->commandBuffers[swapchain->GetActiveImageIndex()];

        if(!commandBuffer->IsRunning()) {
            commandBuffer->SetBeginFlags(VK_COMMAND_BUFFER_USAGE_SIMULTANEOUS_USE_BIT);
            commandBuffer->BeginRecord();
        }

        commandBuffer->BeginRenderPass(renderPass, stage->GetActiveFramebuffer(swapchain->GetActiveImageIndex()),
            stage->GetRenderArea().GetExtent().x, stage->GetRenderArea().GetExtent().y, renderPass.GetColorAttachmentCount(),
            renderPass.GetDepthAttachmentCount(), VK_SUBPASS_CONTENTS_INLINE);

        if(dirty) {
            stage->UpdateViewport(*commandBuffer);
        }


        // End Render Pass

        commandBuffer->EndRenderPass();
        commandBuffer->EndRecord();


        // Submit

        commandBuffer->Submit(perSurfaceBuffer->presentCompletes[perSurfaceBuffer->currentFrame], perSurfaceBuffer->renderCompletes[perSurfaceBuffer->currentFrame],
            perSurfaceBuffer->flightFences[perSurfaceBuffer->currentFrame]);

        auto presentQueue = logicalDevice->GetPresentQueue();
        auto presentResult = swapchain->QueuePresent(presentQueue, perSurfaceBuffer->renderCompletes[perSurfaceBuffer->currentFrame]);

        if(presentResult == VK_ERROR_OUT_OF_DATE_KHR || presentResult == VK_SUBOPTIMAL_KHR) {
            RecreateSwapchain(context);
        }else if(presentResult != VK_SUCCESS) {
            checkVulkan(presentResult);
            SPOOPY_LOG_ERROR("Failed to present swapchain image!");
        }

        perSurfaceBuffer->currentFrame = (perSurfaceBuffer->currentFrame + 1) % swapchain->GetImageCount();
         */
    }

    void GraphicsVulkan::ChangeSize(const SDL_Context &context, const Viewport &viewport) {
        auto &stage = context->stage;
        stage->SetViewport(viewport);
    }
}}