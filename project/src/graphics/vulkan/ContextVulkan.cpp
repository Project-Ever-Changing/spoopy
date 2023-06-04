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
}