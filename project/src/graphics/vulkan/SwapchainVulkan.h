#pragma once

#include "../../device/Surface.h"
#include "GraphicsVulkan.h"

#ifdef SPOOPY_VOLK
#include <volk.h>
#endif

namespace lime {
    class SwapchainVulkan {
        public:
            SwapchainVulkan(GraphicsVulkan* graphics, const Surface &surface, const SwapchainVulkan* oldSwapchain);
            ~SwapchainVulkan();

            int SetVSYNC(int vsync);
        private:
            // VkResult PresentImage(const VkQueue &presentQueue, const VkSemaphore &waitSemaphore = VK_NULL_HANDLE);

            const PhysicalDevice &physicalDevice;
            const LogicalDevice &logicalDevice;
            const Surface &surface;

            VkPresentModeKHR presentMode;
            std::vector<VkPresentModeKHR> physicalPresentModes;
    };
}