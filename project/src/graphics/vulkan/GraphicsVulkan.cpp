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

    /*
     * TODO: This has been a bit of a mess, I need to find another way to handle RenderPasses.
     */
    void GraphicsVulkan::Reset(const RenderPassVulkan &renderPass) {
        // RecreateSwapchains();
    }

    GraphicsVulkan::~GraphicsVulkan() {
        vkDestroyPipelineCache(*logicalDevice, pipelineCache, nullptr);
        contexts.clear();
    }

    void GraphicsVulkan::ChangeSize(const Context &context, const Viewport &viewport) {
        auto &stage = context->stage;
        stage->SetViewport(viewport);
    }
}}