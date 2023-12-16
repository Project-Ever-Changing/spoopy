#include "../../device/Surface.h"
#include "../../device/PhysicalDevice.h"
#include "../../device/LogicalDevice.h"
#include "SwapchainVulkan.h"
#include "ContextStage.h"
#include "../../../include/graphics/ContextLayer.h"

#include <graphics/ContextLayer.h>

namespace lime { namespace spoopy {
    ContextVulkan::ContextVulkan(const std::shared_ptr<QueueVulkan> &queue): queue(queue) {

    }

    ContextVulkan::~ContextVulkan() {

    }

    void ContextVulkan::RecreateSwapchain(const PhysicalDevice &physicalDevice, const LogicalDevice &logicalDevice,
        const VkExtent2D &extent, const SwapchainVulkan *oldSwapchain) {
        //swapchain.reset();
        //swapchain = std::make_unique<SwapchainVulkan>(physicalDevice, *surface, logicalDevice, extent, oldSwapchain, sync);
    }

    void ContextVulkan::DestroySwapchain() {
        swapchain.reset();
    }

    VkResult ContextVulkan::AcquireNextImage(const VkSemaphore &presentCompleteSemaphore, VkFence fence) {
        if(!swapchain) {
            SPOOPY_LOG_ERROR("Attempted to acquire next image without a swapchain!");
            return VK_ERROR_INITIALIZATION_FAILED;
        }

        //return swapchain->AcquireNextImage(presentCompleteSemaphore, fence);
        return VK_SUCCESS;
    }

    uint32_t ContextVulkan::GetImageCount() const {
        if(!swapchain) {
            SPOOPY_LOG_WARN("Attempted to get image count without a swapchain!");
            return 0;
        }

        //return swapchain->GetImageCount();
        return 0;
    }
}}