#pragma once

#include "GraphicsHandlerVulkan.h"

#include <sdl_definitions_config.h>
#include <core/Log.h>

#include <memory>

namespace lime {
    class Surface;
    class SwapchainVulkan;

    class ContextVulkan: public ContextBase {
        public:
            friend class GraphicsHandlerVulkan;

            ContextVulkan();
            ~ContextVulkan();

            void SetSurface(std::unique_ptr<Surface> surface);
            void SetSwapchain(std::unique_ptr<SwapchainVulkan> swapchain);
        private:
            std::unique_ptr<Surface> surface;
            std::unique_ptr<SwapchainVulkan> swapchain;
    };
}