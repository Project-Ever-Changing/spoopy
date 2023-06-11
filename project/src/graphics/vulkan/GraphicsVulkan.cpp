#include "ContextVulkan.h"
#include "GraphicsVulkan.h"

namespace lime { namespace spoopy {
    GraphicsVulkan* GraphicsVulkan::Main = nullptr;

    GraphicsVulkan::GraphicsVulkan(SDL_Window* m_window):
        instance(std::unique_ptr<Instance>(new Instance(m_window))),
        physicalDevice(std::unique_ptr<PhysicalDevice>(new PhysicalDevice(*instance))),
        logicalDevice(std::unique_ptr<LogicalDevice>(new LogicalDevice(*instance, *physicalDevice))),
        contexts(std::vector<std::unique_ptr<ContextVulkan>>()) {

        VkPipelineCacheCreateInfo pipelineCacheCreateInfo = {};
        pipelineCacheCreateInfo.sType = VK_STRUCTURE_TYPE_PIPELINE_CACHE_CREATE_INFO;
        checkVulkan(vkCreatePipelineCache(*logicalDevice, &pipelineCacheCreateInfo, nullptr, &pipelineCache));

        int width, height;
        SDL_GetWindowSize(m_window, &width, &height);
        displayExtent = {static_cast<uint32_t>(width), static_cast<uint32_t>(height)};
    }

    void GraphicsVulkan::Reset() {
        RecreateSwapchains();

        for(auto &context: contexts) {
            auto perSurfaceBuffer = context->GetSurfaceBuffer();

            if(perSurfaceBuffer->flightFences.size() != context->GetImageCount()) {
                context->RecreateCommandBuffers(*logicalDevice);
            }
        }
    }

    void GraphicsVulkan::RecreateSwapchains() {
        vkDeviceWaitIdle(*logicalDevice);

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

        SPOOPY_LOG_INFO("About to be destroyed!");

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

    void GraphicsVulkan::Update() {
        for(auto &context: contexts) {
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
    }
}}