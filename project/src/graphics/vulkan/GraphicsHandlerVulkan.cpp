#include "../../device/Surface.h"
#include "SwapchainVulkan.h"
#include "GraphicsVulkan.h"

#include <sdl_definitions_config.h>

namespace lime { namespace spoopy {
    Context GraphicsHandler::Handler_CreateContext(SDL_Window* m_window) {
        if(!GraphicsVulkan::Main) {
            GraphicsVulkan::Main = std::make_unique<GraphicsVulkan>(m_window);
        }

        auto context = std::shared_ptr<ContextVulkan>(GraphicsVulkan::Main->logicalDevice->CreateContextVulkan());
        GraphicsVulkan::Main->contexts.push_back(context);
        return context;
    }

    void GraphicsHandler::Handler_DestroyContext(const Context &context) {
        auto element = std::find_if(GraphicsVulkan::Main->contexts.begin(), GraphicsVulkan::Main->contexts.end(),
        [context](const Context &contextPtr){
            return contextPtr.get() == context.get();
        });

        if(element == GraphicsVulkan::Main->contexts.end()) {
            return;
        }

        element->reset();
        GraphicsVulkan::Main->contexts.erase(element);

        if(GraphicsVulkan::Main->contexts.empty()) {
            GraphicsVulkan::Main.reset();
        }
    }

    int GraphicsHandler::Handler_MakeCurrent(SDL_Window* m_window, const Context &context) {
        auto element = std::find_if(GraphicsVulkan::Main->contexts.begin(), GraphicsVulkan::Main->contexts.end(),
        [context](const Context &contextPtr) {
            return contextPtr.get() == context.get();
        });

        if(element == GraphicsVulkan::Main->contexts.end()) {
            SPOOPY_LOG_WARN("Context was not found within GraphicsVulkan::Main->contexts");
            return 1;
        }

        context->CreateSurface(
            *GraphicsVulkan::Main->instance,
            *GraphicsVulkan::Main->physicalDevice,
            *GraphicsVulkan::Main->logicalDevice,
            m_window
        );

        return 0;
    }

    int GraphicsHandler::Handler_SwapInterval(int vsync) {
        auto& contexts = GraphicsVulkan::Main->contexts;

        for(size_t i=0; i<contexts.size(); ++i) {
            auto& context = contexts[i];
            context->SetVSYNC(vsync);
        }

        return 0;
    }
}}