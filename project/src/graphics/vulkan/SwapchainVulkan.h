#pragma once

#include <spoopy.h>
#include <vector>

namespace lime {
    class PhysicalDevice;
    class Surface;
    class LogicalDevice;

    class SwapchainVulkan {
        public:
            SwapchainVulkan(const PhysicalDevice &physicalDevice, const Surface &surface, const LogicalDevice &logicalDevice, const VkExtent2D &extent, const SwapchainVulkan* oldSwapchain);
            ~SwapchainVulkan();

            int SetVSYNC(int vsync);
        private:
            // VkResult PresentImage(const VkQueue &presentQueue, const VkSemaphore &waitSemaphore = VK_NULL_HANDLE);

            const PhysicalDevice &physicalDevice;
            const LogicalDevice &logicalDevice;
            const Surface &surface;

            VkExtent2D extent;
            VkPresentModeKHR presentMode;

            std::vector<VkPresentModeKHR> physicalPresentModes;
    };
}