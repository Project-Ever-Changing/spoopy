#include "RenderPassVulkan.h"
#include "SwapchainVulkan.h"
#include "ContextStage.h"
#include "GraphicsVulkan.h"

#include <graphics/ContextLayer.h>

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
    }

    void GraphicsVulkan::RecreateSwapchain(const Context &context) {
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
        for(auto &context: contexts) {
            context->DestroySwapchain();
        }

        vkDestroyPipelineCache(*logicalDevice, pipelineCache, nullptr);
        contexts.clear();
    }

    void GraphicsVulkan::ChangeSize(const Context &context, const Viewport &viewport) {
        auto &stage = context->stage;
        stage->SetViewport(viewport);
    }
}}