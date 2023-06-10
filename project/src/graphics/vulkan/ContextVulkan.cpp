#include "../../device/Surface.h"
#include "../../device/PhysicalDevice.h"
#include "../../device/LogicalDevice.h"
#include "SwapchainVulkan.h"
#include "ContextVulkan.h"

namespace lime { namespace spoopy {
    ContextVulkan::ContextVulkan() {

    }

    ContextVulkan::~ContextVulkan() {

    }

    void ContextVulkan::RecreateSwapchain(const PhysicalDevice &physicalDevice, const LogicalDevice &logicalDevice,
        const VkExtent2D &extent, const SwapchainVulkan *oldSwapchain) {
        swapchain = std::unique_ptr<SwapchainVulkan>(new SwapchainVulkan(physicalDevice, *surface, logicalDevice, extent, oldSwapchain, sync));
        surfaceBuffer = std::unique_ptr<SurfaceBuffer>(new SurfaceBuffer());

        RecreateCommandBuffers(logicalDevice);
    }

    void ContextVulkan::RecreateCommandBuffers(const LogicalDevice &logicalDevice) {
        for(std::size_t i=0; i<surfaceBuffer->flightFences.size(); ++i) {
            vkDestroyFence(logicalDevice, surfaceBuffer->flightFences[i], nullptr);
            vkDestroySemaphore(logicalDevice, surfaceBuffer->renderCompletes[i], nullptr);
            vkDestroySemaphore(logicalDevice, surfaceBuffer->presentCompletes[i], nullptr);
        }

        surfaceBuffer->flightFences.resize(swapchain->GetImageCount());
        surfaceBuffer->renderCompletes.resize(swapchain->GetImageCount());
        surfaceBuffer->presentCompletes.resize(swapchain->GetImageCount());
        surfaceBuffer->commandBuffers.resize(swapchain->GetImageCount());

        VkSemaphoreCreateInfo semaphoreCreateInfo = {};
        semaphoreCreateInfo.sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;

        VkFenceCreateInfo fenceCreateInfo = {};
        fenceCreateInfo.sType = VK_STRUCTURE_TYPE_FENCE_CREATE_INFO;
        fenceCreateInfo.flags = VK_FENCE_CREATE_SIGNALED_BIT;
    }

    void ContextVulkan::DestroySwapchain() {
        swapchain.reset();
    }

    void ContextVulkan::SetSurface(std::unique_ptr<Surface> surface) {
        this->surface = std::move(surface);
    }

    VkResult ContextVulkan::AcquireNextImage(const VkSemaphore &presentCompleteSemaphore, VkFence fence) {
        if(!swapchain) {
            return VK_ERROR_INITIALIZATION_FAILED;
        }

        //return swapchain->AcquireNextImage(presentCompleteSemaphore, fence);
        return VK_ERROR_INITIALIZATION_FAILED;
    }
}}