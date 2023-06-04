#pragma once

#include <sdl_definitions_config.h>
#include <core/Log.h>

#include <memory>

namespace lime {
    class Surface;
    class SwapchainVulkan;

    class ContextVulkan: public ContextBase {
        public:
            friend class GraphicsHandler;

            ContextVulkan();
            ~ContextVulkan();

            void SetSurface(std::unique_ptr<Surface> surface);
        private:
            std::unique_ptr<Surface> surface;
            std::unique_ptr<SwapchainVulkan> swapchain;
    };
}