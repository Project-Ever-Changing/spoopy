#pragma once

#include "../../helpers/SpoopyHelpersVulkan.h"

#include <vector>

namespace lime { namespace spoopy {
    class PhysicalDevice;
    class Surface;
    class LogicalDevice;

    class SwapchainVulkan {
        public:
            SwapchainVulkan(const PhysicalDevice &physicalDevice, const Surface &surface, const LogicalDevice &logicalDevice, const VkExtent2D &extent, const SwapchainVulkan* oldSwapchain, uint8_t vsync);
            ~SwapchainVulkan();

            operator const VkSwapchainKHR &() const { return swapchain; }

            const VkExtent2D &GetExtent() const { return extent; }
            uint32_t GetImageCount() const { return imageCount; }
            VkSurfaceTransformFlagsKHR GetPreTransform() const { return preTransform; }

        private:
            int8_t SetVSYNC(uint8_t vsync);

            // VkResult PresentImage(const VkQueue &presentQueue, const VkSemaphore &waitSemaphore = VK_NULL_HANDLE);

            const PhysicalDevice &physicalDevice;
            const LogicalDevice &logicalDevice;
            const Surface &surface;

            VkExtent2D extent;
            VkPresentModeKHR presentMode;
            VkSwapchainKHR swapchain = VK_NULL_HANDLE;
            VkFence fenceImage = VK_NULL_HANDLE;

            uint32_t imageCount = 0;
            VkSurfaceTransformFlagsKHR preTransform;

            std::vector<VkImage> images;
            std::vector<VkImageView> imageViews;
            std::vector<VkPresentModeKHR> physicalPresentModes;
    };
}}