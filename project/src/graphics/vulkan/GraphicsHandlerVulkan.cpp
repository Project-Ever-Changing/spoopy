#include "ContextVulkan.h"
#include "../../device/Surface.h"
#include "SwapchainVulkan.h"
#include "GraphicsVulkan.h"

#include <sdl_definitions_config.h>

namespace lime { namespace spoopy {
    ContextBase* GraphicsHandler::CreateContext(SDL_Window* m_window) {
        if(!GraphicsVulkan::Main) {
            GraphicsVulkan::Main = new GraphicsVulkan(m_window);
        }

        auto context = new ContextVulkan();
        GraphicsVulkan::Main->contexts.push_back(std::unique_ptr<ContextVulkan>(context));
        return context;
    }

    void GraphicsHandler::DestroyContext(ContextBase* context) {
        auto element = std::find_if(GraphicsVulkan::Main->contexts.begin(), GraphicsVulkan::Main->contexts.end(),
        [context](const std::unique_ptr<ContextVulkan>& contextPtr){
            return contextPtr.get() == context;
        });

        if(GraphicsVulkan::Main->contexts.empty()) {
            delete GraphicsVulkan::Main;
            GraphicsVulkan::Main = nullptr;

            return;
        }

        if(element == GraphicsVulkan::Main->contexts.end()) {
            return;
        }

        GraphicsVulkan::Main->contexts.erase(element);
        delete context;
    }

    int GraphicsHandler::MakeCurrent(SDL_Window* m_window, ContextBase* context) {
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

        vkContext->SetSurface(std::move(surface));
        return 0;
    }

    int GraphicsHandler::SwapInterval(int vsync) {
        auto& contexts = GraphicsVulkan::Main->contexts;

        for(size_t i=0; i<contexts.size(); ++i) {
            auto& context = contexts[i];
            context->SetVSYNC(vsync);
        }

        return 0;
    }
}}