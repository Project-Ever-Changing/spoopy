#include "SwapchainVulkan.h"
#include "../../device/LogicalDevice.h"
#include "../../device/PhysicalDevice.h"
#include "../../device/Surface.h"

namespace lime {
    SwapchainVulkan::SwapchainVulkan(const PhysicalDevice &physicalDevice, const Surface &surface, const LogicalDevice &logicalDevice, const VkExtent2D &extent, const SwapchainVulkan *oldSwapchain):
    physicalDevice(physicalDevice),
    surface(surface),
    logicalDevice(logicalDevice),
    extent(extent),
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