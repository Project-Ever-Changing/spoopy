#include "../../device/Surface.h"
#include "../../device/PhysicalDevice.h"
#include "../../device/LogicalDevice.h"
#include "CommandBufferVulkan.h"
#include "SwapchainVulkan.h"
#include "ContextStage.h"
#include "../../../include/graphics/Context.h"

#include <graphics/Context.h>

namespace lime { namespace spoopy {
    ContextVulkan::ContextVulkan() {

    }

    ContextVulkan::~ContextVulkan() {

    }

    void ContextVulkan::RecreateSwapchain(const PhysicalDevice &physicalDevice, const LogicalDevice &logicalDevice,
        const VkExtent2D &extent, const SwapchainVulkan *oldSwapchain) {
        swapchain.reset();
        surfaceBuffer.reset();

        swapchain = std::make_unique<SwapchainVulkan>(physicalDevice, *surface, logicalDevice, extent, oldSwapchain, sync);
        surfaceBuffer = std::make_unique<SurfaceBuffer>();

        RecreateCommandBuffers(logicalDevice);
    }

    void ContextVulkan::RecreateCommandBuffers(const LogicalDevice &logicalDevice) {
        for(std::size_t i=0; i<surfaceBuffer->flightFences.size(); i++) {
            vkDestroyFence(logicalDevice, surfaceBuffer->flightFences[i], nullptr);
            vkDestroySemaphore(logicalDevice, surfaceBuffer->renderCompletes[i], nullptr);
            vkDestroySemaphore(logicalDevice, surfaceBuffer->presentCompletes[i], nullptr);

            surfaceBuffer->commandBuffers[i].reset();
        }

        const std::size_t imageCount = swapchain->GetImageCount();

        surfaceBuffer->flightFences.resize(imageCount);
        surfaceBuffer->renderCompletes.resize(imageCount);
        surfaceBuffer->presentCompletes.resize(imageCount);
        surfaceBuffer->commandBuffers.resize(imageCount);

        VkSemaphoreCreateInfo semaphoreCreateInfo = {};
        semaphoreCreateInfo.sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;

        VkFenceCreateInfo fenceCreateInfo = {};
        fenceCreateInfo.sType = VK_STRUCTURE_TYPE_FENCE_CREATE_INFO;
        fenceCreateInfo.flags = VK_FENCE_CREATE_SIGNALED_BIT;

        for(std::size_t i=0; i<swapchain->GetImageCount(); i++) {
            checkVulkan(vkCreateSemaphore(logicalDevice, &semaphoreCreateInfo, nullptr, &surfaceBuffer->presentCompletes[i]));
            checkVulkan(vkCreateSemaphore(logicalDevice, &semaphoreCreateInfo, nullptr, &surfaceBuffer->renderCompletes[i]));
            checkVulkan(vkCreateFence(logicalDevice, &fenceCreateInfo, nullptr, &surfaceBuffer->flightFences[i]));

            surfaceBuffer->commandBuffers[i] = std::make_unique<CommandBufferVulkan>(false);
        }
    }

    void ContextVulkan::DestroySwapchain() {
        swapchain.reset();
    }

    VkResult ContextVulkan::AcquireNextImage(const VkSemaphore &presentCompleteSemaphore, VkFence fence) {
        if(!swapchain) {
            SPOOPY_LOG_ERROR("Attempted to acquire next image without a swapchain!");
            return VK_ERROR_INITIALIZATION_FAILED;
        }

        return swapchain->AcquireNextImage(presentCompleteSemaphore, fence);
    }

    uint32_t ContextVulkan::GetImageCount() const {
        if(!swapchain) {
            SPOOPY_LOG_WARN("Attempted to get image count without a swapchain!");
            return 0;
        }

        return swapchain->GetImageCount();
    }
}}