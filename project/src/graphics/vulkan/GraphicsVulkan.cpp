#include "RenderPassVulkan.h"
#include "CommandBufferVulkan.h"
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

    void GraphicsVulkan::RecreateSwapchains() {
        vkDeviceWaitIdle(*logicalDevice);

        for(auto &context: contexts) {
            context->RecreateSwapchain(*physicalDevice, *logicalDevice, displayExtent, context->GetSwapchain());
        }
    }

    GraphicsVulkan::~GraphicsVulkan() {
        SPOOPY_LOG_INFO("About to be destroyed!");

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

        SPOOPY_LOG_INFO("GraphicsVulkan destroyed!");
    }

    void GraphicsVulkan::AcquireNextImage(const SDL_Context &context) {
        auto perSurfaceBuffer = context->GetSurfaceBuffer();
        auto acquireResult = context->AcquireNextImage(perSurfaceBuffer->presentCompletes[perSurfaceBuffer->currentFrame], perSurfaceBuffer->flightFences[perSurfaceBuffer->currentFrame]);

        if(acquireResult == VK_ERROR_OUT_OF_DATE_KHR) {
            RecreateSwapchains();
            return;
        }

        if(acquireResult != VK_SUCCESS && acquireResult != VK_SUBOPTIMAL_KHR) {
            SPOOPY_LOG_ERROR("Failed to acquire next image!");
            return;
        }
    }
}}