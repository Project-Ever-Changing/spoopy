#include "../../device/Surface.h"
#include "SwapchainVulkan.h"
#include "ContextVulkan.h"

namespace lime {
    ContextVulkan::ContextVulkan() {

    }

    ContextVulkan::~ContextVulkan() {

    }

    void ContextVulkan::SetSurface(std::unique_ptr<Surface> surface) {
        this->surface = std::move(surface);
    }

    void ContextVulkan::SetSwapchain(std::unique_ptr<SwapchainVulkan> swapchain) {
        this->swapchain = std::move(swapchain);
    }
}