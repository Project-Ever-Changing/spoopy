#include "SwapchainVulkan.h"

namespace lime {
    SwapchainVulkan::SwapchainVulkan(GraphicsVulkan* graphics, const Surface &surface, const SwapchainVulkan* oldSwapchain):
    physicalDevice(*graphics->GetPhysicalDevice()),
    logicalDevice(*graphics->GetLogicalDevice()),
    surface(surface),
    presentMode(VK_PRESENT_MODE_FIFO_KHR) {
        uint32_t physicalPresentModeCount;
        vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice, surface, &physicalPresentModeCount, nullptr);
        this->physicalPresentModes.resize(physicalPresentModeCount);
        vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice, surface, &physicalPresentModeCount, physicalPresentModes.data());
    }

    int SwapchainVulkan::SetVSYNC(int vsync) {
        switch(vsync) {
            case 0:
                for(const auto &presentMode : physicalPresentModes) {
                    if (presentMode == VK_PRESENT_MODE_MAILBOX_KHR) {
                        this->presentMode = presentMode;
                        return 0; // SUCCESS
                    }
                }

                this->presentMode = VK_PRESENT_MODE_IMMEDIATE_KHR;
                return 0; // SUCCESS
            case 1:
                this->presentMode = VK_PRESENT_MODE_FIFO_KHR;
                return 0; // SUCCESS
            default:
                return -1; // FAILURE
        }
    }

    SwapchainVulkan::~SwapchainVulkan() {

    }
}