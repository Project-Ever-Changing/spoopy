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
    }

    GraphicsVulkan::~GraphicsVulkan() {
        auto graphicsQueue = logicalDevice->GetGraphicsQueue();
        checkVulkan(vkQueueWaitIdle(graphicsQueue));
        vkDestroyPipelineCache(*logicalDevice, pipelineCache, nullptr);
        contexts.clear();

        if(Main && Main == this) {
            delete Main;
            Main = nullptr;
        }
    }

    void GraphicsVulkan::Update() {

    }
}}