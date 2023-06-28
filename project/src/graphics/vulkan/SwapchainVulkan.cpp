#include "../../device/LogicalDevice.h"
#include "../../device/PhysicalDevice.h"
#include "../../device/Surface.h"
#include "images/Image.h"
#include "SwapchainVulkan.h"

#include <array>

namespace lime { namespace spoopy {
    SwapchainVulkan::SwapchainVulkan(const PhysicalDevice &physicalDevice, const Surface &surface, const LogicalDevice &logicalDevice, const VkExtent2D &extent, const SwapchainVulkan *oldSwapchain, uint8_t vsync):
    physicalDevice(physicalDevice),
    surface(surface),
    logicalDevice(logicalDevice),
    extent(extent),
    presentMode(VK_PRESENT_MODE_FIFO_KHR),
    activeImageIndex(UINT32_MAX) {
        uint32_t physicalPresentModeCount;
        vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice, surface, &physicalPresentModeCount, nullptr);
        this->physicalPresentModes.resize(physicalPresentModeCount);
        vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice, surface, &physicalPresentModeCount, physicalPresentModes.data());

        if(SetVSYNC(vsync) == -1) {
            SPOOPY_LOG_ERROR("Invalid value for VSYNC: Accepted values are 0 (for immediate mode) or 1 (for FIFO mode).");
        }

        auto surfaceFormat = surface.GetFormat();
        auto surfaceCapabilities = surface.GetCapabilities();
        auto graphicsFamily = logicalDevice.GetGraphicsFamily();
        auto presentFamily = logicalDevice.GetPresentFamily();

        auto desiredImageCount = surfaceCapabilities.minImageCount + 1;

        if(surfaceCapabilities.maxImageCount > 0 && desiredImageCount > surfaceCapabilities.maxImageCount) {
            desiredImageCount = surfaceCapabilities.maxImageCount;
        }

        if(surfaceCapabilities.supportedTransforms & VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR) {
            preTransform = VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR;
        }else {
            preTransform = surfaceCapabilities.currentTransform;
        }

        VkSwapchainCreateInfoKHR swapchainCreateInfo = {};
        swapchainCreateInfo.sType = VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR;
        swapchainCreateInfo.surface = surface;
        swapchainCreateInfo.minImageCount = desiredImageCount;
        swapchainCreateInfo.imageFormat = surfaceFormat.format;
        swapchainCreateInfo.imageColorSpace = surfaceFormat.colorSpace;
        swapchainCreateInfo.imageExtent = this->extent;
        swapchainCreateInfo.imageArrayLayers = 1;
        swapchainCreateInfo.imageUsage = VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT;
        swapchainCreateInfo.imageSharingMode = VK_SHARING_MODE_EXCLUSIVE;
        swapchainCreateInfo.preTransform = static_cast<VkSurfaceTransformFlagBitsKHR>(preTransform);
        swapchainCreateInfo.compositeAlpha = VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR;
        swapchainCreateInfo.presentMode = this->presentMode;
        swapchainCreateInfo.clipped = VK_TRUE;
        swapchainCreateInfo.oldSwapchain = VK_NULL_HANDLE;

        if(surfaceCapabilities.supportedUsageFlags & VK_IMAGE_USAGE_TRANSFER_SRC_BIT) {
            swapchainCreateInfo.imageUsage |= VK_IMAGE_USAGE_TRANSFER_SRC_BIT;
        }

        if(surfaceCapabilities.supportedUsageFlags & VK_IMAGE_USAGE_TRANSFER_DST_BIT) {
            swapchainCreateInfo.imageUsage |= VK_IMAGE_USAGE_TRANSFER_DST_BIT;
        }

        if(oldSwapchain) {
            swapchainCreateInfo.oldSwapchain = oldSwapchain->swapchain;
        }

        if(graphicsFamily != presentFamily) {
            std::array<uint32_t, 2> queueFamily = {graphicsFamily, presentFamily};
            swapchainCreateInfo.imageSharingMode = VK_SHARING_MODE_CONCURRENT;
            swapchainCreateInfo.queueFamilyIndexCount = static_cast<uint32_t>(queueFamily.size());
            swapchainCreateInfo.pQueueFamilyIndices = queueFamily.data();
        }

        checkVulkan(vkCreateSwapchainKHR(logicalDevice, &swapchainCreateInfo, nullptr, &swapchain));
        checkVulkan(vkGetSwapchainImagesKHR(logicalDevice, swapchain, &imageCount, nullptr));

        images.resize(imageCount);
        imageViews.resize(imageCount);

        checkVulkan(vkGetSwapchainImagesKHR(logicalDevice, swapchain, &imageCount, images.data()));

        for(int32_t i=0; i<imageCount; i++) {
            Image::CreateImageView(logicalDevice, images.at(i), imageViews.at(i), VK_IMAGE_VIEW_TYPE_2D, surfaceFormat.format, VK_IMAGE_ASPECT_COLOR_BIT, 1, 0, 1, 0);
        }

        VkFenceCreateInfo fenceCreateInfo = {};
        fenceCreateInfo.sType = VK_STRUCTURE_TYPE_FENCE_CREATE_INFO;
        vkCreateFence(logicalDevice, &fenceCreateInfo, nullptr, &fenceImage);
    }

    int8_t SwapchainVulkan::SetVSYNC(uint8_t vsync) {
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

    VkResult SwapchainVulkan::AcquireNextImage(const VkSemaphore &presentCompleteSemaphore, VkFence fence) {
        if(fence != VK_NULL_HANDLE) {
            checkVulkan(vkWaitForFences(logicalDevice, 1, &fence, VK_TRUE, UINT64_MAX));
        }

        auto acquireResult = vkAcquireNextImageKHR(logicalDevice, swapchain, UINT64_MAX, presentCompleteSemaphore, VK_NULL_HANDLE, &activeImageIndex);

        if(acquireResult != VK_SUCCESS && acquireResult != VK_SUBOPTIMAL_KHR && acquireResult != VK_ERROR_OUT_OF_DATE_KHR) {
            throw std::runtime_error("Failed to acquire next image.");
        }

        return acquireResult;
    }

    SwapchainVulkan::~SwapchainVulkan() {
        vkDestroySwapchainKHR(logicalDevice, swapchain, nullptr);

        for(const auto &imageView: imageViews) {
            vkDestroyImageView(logicalDevice, imageView, nullptr);
        }

        vkDestroyFence(logicalDevice, fenceImage, nullptr);
    }
}}