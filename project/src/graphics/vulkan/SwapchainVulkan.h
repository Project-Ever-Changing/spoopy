#pragma once

#include <spoopy.h>
#include <vector>

namespace lime { namespace spoopy {
    class PhysicalDevice;
    class Surface;
    class LogicalDevice;

    class SwapchainVulkan {
        public:
            SwapchainVulkan(const PhysicalDevice &physicalDevice, const Surface &surface, const LogicalDevice &logicalDevice, const VkExtent2D &extent, const SwapchainVulkan* oldSwapchain, uint8_t vsync);
            ~SwapchainVulkan();
        private:
            uint8_t SetVSYNC(uint8_t vsync);

            // VkResult PresentImage(const VkQueue &presentQueue, const VkSemaphore &waitSemaphore = VK_NULL_HANDLE);

            const PhysicalDevice &physicalDevice;
            const LogicalDevice &logicalDevice;
            const Surface &surface;

            VkExtent2D extent;
            VkPresentModeKHR presentMode;

            std::vector<VkPresentModeKHR> physicalPresentModes;
    };
}}