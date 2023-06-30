#include "../../device/Surface.h"
#include "SwapchainVulkan.h"
#include "GraphicsVulkan.h"

#include <sdl_definitions_config.h>

namespace lime { namespace spoopy {
    SDL_Context GraphicsHandler::CreateContext(SDL_Window* m_window) {
        if(!GraphicsVulkan::Main) {
            GraphicsVulkan::Main = std::make_unique<GraphicsVulkan>(m_window);
        }

        auto context = std::make_shared<ContextVulkan>();
        GraphicsVulkan::Main->contexts.push_back(context);
        return context;
    }

    void GraphicsHandler::DestroyContext(const SDL_Context &context) {
        auto element = std::find_if(GraphicsVulkan::Main->contexts.begin(), GraphicsVulkan::Main->contexts.end(),
        [context](const SDL_Context &contextPtr){
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

    int GraphicsHandler::MakeCurrent(SDL_Window* m_window, const SDL_Context &context) {
        auto element = std::find_if(GraphicsVulkan::Main->contexts.begin(), GraphicsVulkan::Main->contexts.end(),
        [context](const SDL_Context &contextPtr) {
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

    int GraphicsHandler::SwapInterval(int vsync) {
        auto& contexts = GraphicsVulkan::Main->contexts;

        for(size_t i=0; i<contexts.size(); ++i) {
            auto& context = contexts[i];
            context->SetVSYNC(vsync);
        }

        return 0;
    }
}}