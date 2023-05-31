#include "SwapchainVulkan.h"
#include "GraphicsHandlerVulkan.h"

namespace lime {
    ContextBase* GraphicsHandlerVulkan::CreateContext(SDL_Window* m_window) {
        if(!GraphicsVulkan::Main) {
            GraphicsVulkan::Main = new GraphicsVulkan(m_window);
        }

        auto context = new ContextVulkan();
        GraphicsVulkan::Main->contexts.push_back(std::unique_ptr<ContextVulkan>(context));
        return context;
    }

    void GraphicsHandlerVulkan::DestroyContext(ContextBase* context) {
        auto element = std::find_if(GraphicsVulkan::Main->contexts.begin(), GraphicsVulkan::Main->contexts.end(),
        [context](const std::unique_ptr<ContextVulkan>& contextPtr){
            return contextPtr.get() == context;
        });

        if(element == GraphicsVulkan::Main->contexts.end()) {
            return;
        }

        GraphicsVulkan::Main->contexts.erase(element);
        delete context;
    }

    int GraphicsHandlerVulkan::MakeCurrent(SDL_Window* m_window, ContextBase* context) {
        auto vkContext = static_cast<ContextVulkan*>(context);
        auto element = std::find_if(GraphicsVulkan::Main->contexts.begin(), GraphicsVulkan::Main->contexts.end(),
        [vkContext](const std::unique_ptr<ContextVulkan>& contextPtr){
            return contextPtr.get() == vkContext;
        });

        if(element == GraphicsVulkan::Main->contexts.end()) {
            SPOOPY_LOG_WARN("Context was not found within GraphicsVulkan::Main->contexts");
            return 1;
        }

        std::unique_ptr<Surface> surface = std::unique_ptr<Surface>(new Surface(
                *GraphicsVulkan::Main->instance,
                *GraphicsVulkan::Main->physicalDevice,
                *GraphicsVulkan::Main->logicalDevice,
                m_window
        ));

        std::unique_ptr<SwapchainVulkan> swapchain = std::unique_ptr<SwapchainVulkan>(new SwapchainVulkan(
                GraphicsVulkan::Main,
                *surface.get(),
                nullptr
        ));

        vkContext->SetSurface(std::move(surface));
        vkContext->SetSwapchain(std::move(swapchain));
        return 0;
    }

    int GraphicsHandlerVulkan::SwapInterval(int vsync) {
        auto& contexts = GraphicsVulkan::Main->contexts;

        for(size_t i=0; i<contexts.size(); ++i) {
            auto& context = contexts[i];

            if(context->swapchain->SetVSYNC(vsync) == -1) {
                SPOOPY_LOG_WARN("Failed to set VSYNC for context!");
                printf("%s%lu\n", "Index of context: ", i);
                return -1;
            }
        }

        return 0;
    }
}