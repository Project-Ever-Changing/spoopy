#include "../../device/Surface.h"
#include "../../device/LogicalDevice.h"
#include "../../device/PhysicalDevice.h"
#include "../../helpers/SpoopyHelpersVulkan.h"
#include "components/SemaphoreVulkan.h"
#include "components/FenceVulkan.h"
#include "SwapchainVulkan.h"
#include "QueueVulkan.h"

#include <core/Log.h>
#include <spoopy_assert.h>
#include <spoopy.h>

#ifdef ANDROID
bool vkKeepSwapchain = false;
#else
bool vkKeepSwapchain = true;
#endif

namespace lime { namespace spoopy {

    /*
     * After the swapchain is created, we need to create attachments for the command buffers to render to.
     * This is done on the frontend side, in Haxe.
     */
    SwapchainVulkan::SwapchainVulkan(int32 width, int32 height, VkSwapchainKHR &oldSwapchain, bool vsync
    , LogicalDevice &device, const PhysicalDevice &physicalDevice, const ContextVulkan &context)
    : device(device)
    , physicalDevice(physicalDevice)
    , Swapchain(context)
    , swapchain(VK_NULL_HANDLE)
    , acquiredImageIndex(-1)
    , currentImageIndex(-1)
    , vsync(vsync) {
        Create(oldSwapchain);
    }

    void SwapchainVulkan::Create(const VkSwapchainKHR &oldSwapchain) {
        /*
         * Parts needed to create a swapchain:
         *
         * - Surface Creation (When needed) ✅
         * - Presentation mode ✅
         * - Surface Capabilities ✅
         * - Swapchain Create Info ✅
         * - Swapchain Get Images ✅
         * - Swapchain Create Image Views ✅
         */


        // Surface Creation (When needed) (1)
        // Since I'm using SDL_Vulkan_CreateSurface, I don't need to create the surface everytime I create a swapchain.

        VkSurfaceKHR surface = context.GetSurface()->GetSurface();
        if(surface == VK_NULL_HANDLE) context.GetSurface()->CreateSurface();

        const uint32_t minSwapBufferCount = std::max<uint32_t>(context.GetSurface()->GetCapabilities().minImageCount, 2);
        const uint32_t maxSwapBufferCount = context.GetSurface()->GetCapabilities().maxImageCount == 0
                                            ? VK_MAX_BACK_BUFFERS
                                            : std::min<uint32_t>(context.GetSurface()->GetCapabilities().maxImageCount, VK_MAX_BACK_BUFFERS);

        if(minSwapBufferCount > maxSwapBufferCount) {
            SPOOPY_LOG_ERROR("minImageCount is greater than maxImageCount!");
            return;
        }

        const uint32_t swapBufferCount = std::clamp<uint32_t>(VK_BACK_BUFFERS_COUNT, minSwapBufferCount, maxSwapBufferCount);
        device.SetupPresentQueue(*context.GetSurface());

        SPOOPY_LOG_INFO("(1)");


        // Present mode (2)

        VkPresentModeKHR presentMode = VK_PRESENT_MODE_FIFO_KHR;

        unsigned int presentModesCount = 0;
        checkVulkan(vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice, surface, &presentModesCount, nullptr));
        SP_ASSERT(presentModesCount > 0);

        SPOOPY_LOG_INFO("(1.25)");

        std::vector<VkPresentModeKHR> presentModes(presentModesCount); // Too risky to allocate from the heap, it's safe to use a vector here to avoid potential memory leaks.
        checkVulkan(vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice, surface, &presentModesCount, presentModes.data()));

        bool foundPresentModeMailbox = false;
        bool foundPresentModeImmediate = false;
        bool foundPresentModeFifo = false;

        SPOOPY_LOG_INFO("(1.5)");

        for (const auto &mode: presentModes) { // A range-based for loop is much better here.
            switch(mode) {
                case VK_PRESENT_MODE_IMMEDIATE_KHR:
                    foundPresentModeImmediate = true;
                    break;
                case VK_PRESENT_MODE_FIFO_KHR:
                    foundPresentModeFifo = true;
                    break;
                case VK_PRESENT_MODE_MAILBOX_KHR:
                    foundPresentModeMailbox = true;
                    break;
                default:
                    break;
            }
        }

        if(foundPresentModeImmediate && !vsync) {
            presentMode = VK_PRESENT_MODE_IMMEDIATE_KHR;
        } else if(foundPresentModeMailbox) {
            presentMode = VK_PRESENT_MODE_MAILBOX_KHR;
        } else if(foundPresentModeFifo) {
            presentMode = VK_PRESENT_MODE_FIFO_KHR;
        } else {
            SPOOPY_LOG_WARN("Could not find the proper present mode!");
            presentMode = presentModes[0];
        }

        SPOOPY_LOG_INFO("(2)");


        // Surface capabilities (3)

        VkSurfaceCapabilitiesKHR surfaceCapabilities = context.GetSurface()->GetCapabilities();
        width = std::clamp<int32_t>(width, surfaceCapabilities.minImageExtent.width, surfaceCapabilities.maxImageExtent.width);
        height = std::clamp<int32_t>(height, surfaceCapabilities.minImageExtent.height, surfaceCapabilities.maxImageExtent.height);

        if(width <= 0 || height <= 0) {
            SPOOPY_LOG_ERROR("Vulkan swapchain width or height is invalid!");
            return;
        }

        SPOOPY_LOG_INFO("(3)");


        // Swapchain create info (4)

        VkSwapchainCreateInfoKHR swapChainInfo;
        swapChainInfo.sType = VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR;
        swapChainInfo.surface = surface;
        swapChainInfo.minImageCount = swapBufferCount;
        swapChainInfo.imageFormat = context.GetSurface()->GetFormat().format;
        swapChainInfo.imageColorSpace = context.GetSurface()->GetFormat().colorSpace;
        swapChainInfo.imageExtent.width = width;
        swapChainInfo.imageExtent.height = height;
        swapChainInfo.imageUsage = VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT | VK_IMAGE_USAGE_TRANSFER_DST_BIT;

        #ifdef SPOOPY_USE_WINDOW_SRV
        swapChainInfo.imageUsage |= VK_IMAGE_USAGE_SAMPLED_BIT;
        #endif

        swapChainInfo.preTransform = surfaceCapabilities.currentTransform;
        if(surfaceCapabilities.supportedTransforms & VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR) {
            swapChainInfo.preTransform = VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR;
        }

        swapChainInfo.presentMode = presentMode;
        swapChainInfo.clipped = VK_TRUE;
        swapChainInfo.oldSwapchain = (oldSwapchain != VK_NULL_HANDLE) ? oldSwapchain : VK_NULL_HANDLE;
        swapChainInfo.compositeAlpha = VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR;

        if(surfaceCapabilities.supportedCompositeAlpha & VK_COMPOSITE_ALPHA_INHERIT_BIT_KHR) {
            swapChainInfo.compositeAlpha = VK_COMPOSITE_ALPHA_INHERIT_BIT_KHR;
        }else if(surfaceCapabilities.supportedCompositeAlpha & VK_COMPOSITE_ALPHA_PRE_MULTIPLIED_BIT_KHR) {
            swapChainInfo.compositeAlpha = VK_COMPOSITE_ALPHA_PRE_MULTIPLIED_BIT_KHR;
        }else if(surfaceCapabilities.supportedCompositeAlpha & VK_COMPOSITE_ALPHA_POST_MULTIPLIED_BIT_KHR) {
            swapChainInfo.compositeAlpha = VK_COMPOSITE_ALPHA_POST_MULTIPLIED_BIT_KHR;
        }

        VkBool32 supportsPresent;
        checkVulkan(vkGetPhysicalDeviceSurfaceSupportKHR(physicalDevice, context.GetQueue()->GetFamilyIndex()
        , surface, &supportsPresent));
        SP_ASSERT(supportsPresent);
        checkVulkan(vkCreateSwapchainKHR(device, &swapChainInfo, nullptr, &swapchain));

        this->width = width;
        this->height = height;

        SPOOPY_LOG_INFO("(4)");


        // Swapchain images (5)

        unsigned int swapChainImagesCount = 0;
        checkVulkan(vkGetSwapchainImagesKHR(device, swapchain, &swapChainImagesCount, nullptr));
        SP_ASSERT(swapChainImagesCount >= VK_BACK_BUFFERS_COUNT && swapChainImagesCount <= VK_MAX_BACK_BUFFERS);

        images.reserve(swapChainImagesCount);
        checkVulkan(vkGetSwapchainImagesKHR(device, swapchain, &swapChainImagesCount, images.data()));

        SPOOPY_LOG_INFO("(5)");


        // Swapchain image views (6)

        VkImageViewCreateInfo imageViewInfo = {};
        imageViewInfo.sType = VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
        imageViewInfo.viewType = VK_IMAGE_VIEW_TYPE_2D;
        imageViewInfo.format = context.GetSurface()->GetFormat().format;
        imageViewInfo.components.r = VK_COMPONENT_SWIZZLE_R;
        imageViewInfo.components.g = VK_COMPONENT_SWIZZLE_G;
        imageViewInfo.components.b = VK_COMPONENT_SWIZZLE_B;
        imageViewInfo.components.a = VK_COMPONENT_SWIZZLE_A;
        imageViewInfo.subresourceRange.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
        imageViewInfo.subresourceRange.baseMipLevel = 0;
        imageViewInfo.subresourceRange.levelCount = 1;
        imageViewInfo.subresourceRange.baseArrayLayer = 0;
        imageViewInfo.subresourceRange.layerCount = 1;

        imageViews.reserve(swapChainImagesCount);
        for(uint32_t i=0; i<swapChainImagesCount; i++) {
            imageViewInfo.image = images[i];
            checkVulkan(vkCreateImageView(device, &imageViewInfo, nullptr, &imageViews[i]));
        }

        SPOOPY_LOG_INFO("(6)");
    }

    /*
     * This is a good start for this behemoth of a system, however it is not complete, and in the Haxe side of things
     * there should be wrapper methods for this such as, TryPresent and Present, which will handle the semaphore, fence,
     * and submit the command buffer, and then present the image.
     */
    SwapchainVulkan::SwapchainStatus SwapchainVulkan::Present(QueueVulkan* queue, SemaphoreVulkan* waitSemaphore) {
        SP_ASSERT(currentImageIndex == -1);

        VkPresentInfoKHR presentInfo = {};
        presentInfo.sType = VK_STRUCTURE_TYPE_PRESENT_INFO_KHR;

        VkSemaphore semaphore = VK_NULL_HANDLE;

        if(waitSemaphore) {
            presentInfo.waitSemaphoreCount = 1;
            semaphore = waitSemaphore->GetSemaphore();
            presentInfo.pWaitSemaphores = &semaphore;
        }

        presentInfo.swapchainCount = 1;
        presentInfo.pSwapchains = &swapchain;
        presentInfo.pImageIndices = (uint32_t*)&currentImageIndex;

        const VkResult result = vkQueuePresentKHR(queue->GetQueue(), &presentInfo);

        switch(result) {
            case VK_SUBOPTIMAL_KHR:
            case VK_ERROR_OUT_OF_DATE_KHR: return SwapchainStatus::OUT_OF_DATE;
            case VK_ERROR_SURFACE_LOST_KHR: return SwapchainStatus::LOST_SURFACE;
            case VK_SUCCESS:
                Swapchain::Present();
                return SwapchainStatus::OK;
            default:
                checkVulkan(result);
                return SwapchainStatus::OTHER;
        }
    }

    /*
     * While acquiring info about next image, we also reset fence and tell the frontend that the semaphore
     * specified in the index is valid and available for use.
     */
    int32 SwapchainVulkan::AcquireNextImage(value imageAvailableSemaphore
    , FenceVulkan* fence, int32 prevSemaphoreIndex, int32 semaphoreIndex) {
        SP_ASSERT(currentImageIndex == -1);

        if(presentCounter == 0) {
            SPOOPY_LOG_ERROR("Swapchain::AcquireNextImage called with no images being presented!");
            return -1;
        }

        uint32_t imageIndex = 0;

        #ifdef VK_USE_IMAGE_ACQUIRE_FENCES
        fence->Reset();
        VkFence fenceHandle = fence->GetHandle();
        #else
        VkFence fenceHandle = VK_NULL_HANDLE;
        #endif

        VkResult result;

        const value semaphore = val_array_i(imageAvailableSemaphore, semaphoreIndex);
        const SemaphoreVulkan& rawSemaphore = *(SemaphoreVulkan*)val_data(semaphore);

        result = vkAcquireNextImageKHR(
            device,
            swapchain,
            UINT64_MAX,
            rawSemaphore,
            fenceHandle,
            &imageIndex
        );

        if(result == VK_ERROR_OUT_OF_DATE_KHR) {
            SPOOPY_LOG_WARN("Swapchain::AcquireNextImage returned out of date!");
            return (int32)SwapchainStatus::OUT_OF_DATE;
        }

        if(result == VK_ERROR_SURFACE_LOST_KHR) {
            SPOOPY_LOG_WARN("Swapchain::AcquireNextImage returned lost surface!");
            return (int32)SwapchainStatus::LOST_SURFACE;
        }

        if(result == VK_ERROR_VALIDATION_FAILED_EXT) {
            SPOOPY_LOG_ERROR("Validation failed while acquiring next image!");
        }

        currentImageIndex = (int32)imageIndex;

        #ifdef VK_USE_IMAGE_ACQUIRE_FENCES
        fence->Wait(UINT64_MAX);
        #endif

        return currentImageIndex;
    }

    void SwapchainVulkan::ReleaseImageViews() {
        for(int32 i=0; i<imageViews.size(); i++) {
            vkDestroyImageView(device, imageViews[i], nullptr);
            imageViews.erase(imageViews.begin() + i);
        }
    }

    void SwapchainVulkan::ReleaseImages() {
        for(int32 i=0; i<images.size(); i++) {
            vkDestroyImage(device, images[i], nullptr);
            images.erase(images.begin() + i);
        }
    }

    /*
     * Have the front end handle the swapchain deletion of resources such as flushing command buffers
     * , deleting the acquired fences and semaphores, and back buffers.
     *
     * Also, the reason why I choose to set it up this way is because Haxe code is much easier to read than C++ code
     */
    void SwapchainVulkan::Destroy(VkSwapchainKHR &oldSwapchain) {
        // The flushing of command buffers should be called before calling this method

        device.WaitForGPU();

        ReleaseImages();
        ReleaseImageViews();

        acquiredImageIndex = -1;
        currentImageIndex = -1;

        // Destroy the old swapchain if it exists, Vulkan does not have a GC for old swapchains
        // , so we have to do it manually.
        if(oldSwapchain != VK_NULL_HANDLE) {
            vkDestroySwapchainKHR(device, oldSwapchain, nullptr);
        }

        bool shouldRecreate = (oldSwapchain != VK_NULL_HANDLE) && vkKeepSwapchain;
        if(shouldRecreate) {
            vkDestroySwapchainKHR(device, swapchain, nullptr);
        }else {
            oldSwapchain = swapchain;
        }
        swapchain = VK_NULL_HANDLE;
        width = height = 0;
        presentCounter = 0;

        // The front end will handle flushing the acquired fences and semaphores.
    }
}}