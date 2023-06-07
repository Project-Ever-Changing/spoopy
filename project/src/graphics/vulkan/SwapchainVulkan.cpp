#include "SwapchainVulkan.h"
#include "../../device/LogicalDevice.h"
#include "../../device/PhysicalDevice.h"
#include "../../device/Surface.h"

namespace lime { namespace spoopy {
    SwapchainVulkan::SwapchainVulkan(const PhysicalDevice &physicalDevice, const Surface &surface, const LogicalDevice &logicalDevice, const VkExtent2D &extent, const SwapchainVulkan *oldSwapchain, uint8_t vsync):
    physicalDevice(physicalDevice),
    surface(surface),
    logicalDevice(logicalDevice),
    extent(extent),
    presentMode(VK_PRESENT_MODE_FIFO_KHR) {
        uint32_t physicalPresentModeCount;
        vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice, surface, &physicalPresentModeCount, nullptr);
        this->physicalPresentModes.resize(physicalPresentModeCount);
        vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice, surface, &physicalPresentModeCount, physicalPresentModes.data());

        if(SetVSYNC(vsync) == -1) {
            SPOOPY_LOG_ERROR("Invalid value for VSYNC: Accepted values are 0 (for immediate mode) or 1 (for FIFO mode).");
        }
    }

    uint8_t SwapchainVulkan::SetVSYNC(uint8_t vsync) {
        switch(vsync) {
            case 0:
                for(const auto &presentMode: physicalPresentModes) {
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
}}