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
    SwapchainVulkan::SwapchainVulkan(int32 width, int32 height, SwapchainVulkan* oldSwapchain, bool vsync,
    , LogicalDevice &device, const PhysicalDevice &physicalDevice, const ContextVulkan &context)
    : GPUResource(device)
    , physicalDevice(physicalDevice)
    , Swapchain(context)
    , swapchain(VK_NULL_HANDLE)
    , acquiredImageIndex(-1)
    , currentImageIndex(-1)
    , vsync(vsync) {
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


         // Present mode (1)

        VkPresentModeKHR presentMode = VK_PRESENT_MODE_FIFO_KHR;

        unsigned int presentModesCount = 0;
        checkVulkan(vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice, surface, &presentModesCount, nullptr));
        SP_ASSERT(presentModesCount > 0);

        std::vector<VkPresentModeKHR> presentModes(presentModesCount); // Too risky to allocate from the heap, it's safe to use a vector here to avoid potential memory leaks.
        checkVulkan(vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice, surface, &presentModesCount, presentModes.data()));

        bool foundPresentModeMailbox = false;
        bool foundPresentModeImmediate = false;
        bool foundPresentModeFifo = false;

        for (size_t i=0; i < presentModesCount; i++) { // I sadly can't use a switch here because CLion is dumb
            const VkPresentModeKHR& mode = presentModes[i]; // Yes I use CLion, don't ask why and how I can afford it
            
            if(mode == VK_PRESENT_MODE_IMMEDIATE_KHR && !vsync) {
                foundPresentModeFifo = true;
            }else if(mode == VK_PRESENT_MODE_FIFO_KHR) {
                foundPresentModeImmediate = true;
            }else if(mode == VK_PRESENT_MODE_MAILBOX_KHR) {
                foundPresentModeMailbox = true;
            }
        }

        if(foundPresentModeMailbox) {
            presentMode = VK_PRESENT_MODE_MAILBOX_KHR;
        } else if(foundPresentModeImmediate) {
            presentMode = VK_PRESENT_MODE_IMMEDIATE_KHR;
        } else if(foundPresentModeFifo) {
            presentMode = VK_PRESENT_MODE_FIFO_KHR;
        } else {
            SPOOPY_LOG_WARN("Could not find the proper present mode!");
            presentMode = presentModes[0];
        }


        // Surface capabilities (2)

        VkSurfaceCapabilitiesKHR surfaceCapabilities;
        checkVulkan(vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice, surface, &surfaceCapabilities));

        width = std::clamp<int32_t>(width, surfaceCapabilities.minImageExtent.width, surfaceCapabilities.maxImageExtent.width);
        height = std::clamp<int32_t>(height, surfaceCapabilities.minImageExtent.height, surfaceCapabilities.maxImageExtent.height);

        if(width <= 0 || height <= 0) {
            SPOOPY_LOG_ERROR("Vulkan swapchain width or height is invalid!");
            return;
        }


        // Swapchain create info (3)

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

        VkSurfaceCapabilitiesKHR surfProperties = context.GetSurface()->GetCapabilities();
        if(surfProperties.supportedTransforms & VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR) {
            swapChainInfo.preTransform = VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR;
        }

        swapChainInfo.presentMode = presentMode;
        swapChainInfo.clipped = VK_TRUE;
        swapChainInfo.oldSwapchain = (oldSwapchain) ? oldSwapchain->GetHandle() : VK_NULL_HANDLE;
        swapChainInfo.compositeAlpha = VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR;

        if(surfProperties.supportedCompositeAlpha & VK_COMPOSITE_ALPHA_INHERIT_BIT_KHR) {
            swapChainInfo.compositeAlpha = VK_COMPOSITE_ALPHA_INHERIT_BIT_KHR;
        }else if(surfProperties.supportedCompositeAlpha & VK_COMPOSITE_ALPHA_PRE_MULTIPLIED_BIT_KHR) {
            swapChainInfo.compositeAlpha = VK_COMPOSITE_ALPHA_PRE_MULTIPLIED_BIT_KHR;
        }else if(surfProperties.supportedCompositeAlpha & VK_COMPOSITE_ALPHA_POST_MULTIPLIED_BIT_KHR) {
            swapChainInfo.compositeAlpha = VK_COMPOSITE_ALPHA_POST_MULTIPLIED_BIT_KHR;
        }

        VkBool32 supportsPresent;
        checkVulkan(vkGetPhysicalDeviceSurfaceSupportKHR(physicalDevice, context.GetQueue()->GetFamilyIndex()
        , surface, &supportsPresent));
        SP_ASSERT(supportsPresent);
        checkVulkan(vkCreateSwapchainKHR(device, &swapChainInfo, nullptr, &swapchain));

        this->width = width;
        this->height = height;


        // Swapchain images (4)

        unsigned int swapChainImagesCount = 0;
        checkVulkan(vkGetSwapchainImagesKHR(device, swapchain, &swapChainImagesCount, nullptr));
        SP_ASSERT(swapChainImagesCount >= VK_BACK_BUFFERS_COUNT && swapChainImagesCount <= VK_MAX_BACK_BUFFERS);

        images.resize(swapChainImagesCount);
        checkVulkan(vkGetSwapchainImagesKHR(device, swapchain, &swapChainImagesCount, images.data()));


        // Swapchain image views (5)

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

        imageViews.resize(swapChainImagesCount);

        for(uint32_t i=0; i< swapChainImagesCount; i++) {
            imageViewInfo.image = images[i];
            checkVulkan(vkCreateImageView(device, &imageViewInfo, nullptr, &imageViews[i]));
        }
    }

    /*
     * This is a good start for this behemoth of a system, however it is not complete, and in the Haxe side of things
     * there should be wrapper methods for this such as, TryPresent and Present, which will handle the semaphore, fence,
     * and submit the command buffer, and then present the image.
     */
    SwapchainVulkan::SwapchainStatus SwapchainVulkan::Present(const QueueVulkan &queue, SemaphoreVulkan* waitSemaphore) {
        SP_ASSERT(currentImageIndex == -1);

        VkPresentInfoKHR presentInfo = {};
        presentInfo.sType = VK_STRUCTURE_TYPE_PRESENT_INFO_KHR;

        VkSemaphore semaphore = VK_NULL_HANDLE;

        if(waitSemaphore) {
            presentInfo.waitSemaphoreCount = 1;
            semaphore = waitSemaphore->GetHandle();
            presentInfo.pWaitSemaphores = &semaphore;
        }

        presentInfo.swapchainCount = 1;
        presentInfo.pSwapchains = &swapchain;
        presentInfo.pImageIndices = (uint32_t*)&currentImageIndex;

        const VkResult result = vkQueuePresentKHR(queue, &presentInfo);

        if (result == VK_ERROR_OUT_OF_DATE_KHR) {
            return SwapchainStatus::OUT_OF_DATE;
        }

        if (result == VK_ERROR_SURFACE_LOST_KHR) {
            return SwapchainStatus::LOST_SURFACE;
        }

        if(result != VK_SUCCESS && result != VK_SUBOPTIMAL_KHR) {
            checkVulkan(result);
        }

        return SwapchainStatus::OK;
    }

    /*
     * While acquiring info about next image, we also reset fence and tell the frontend that the semaphore
     * specified in the index is valid and available for use.
     */
    int32 SwapchainVulkan::AcquireNextImage(value imageAvailableSemaphore
    , FenceVulkan* fence, int32 prevSemaphoreIndex, int32 semaphoreIndex) {
        SP_ASSERT(currentImageIndex == -1);

        uint32_t imageIndex = 0;

        #ifdef VK_USE_IMAGE_ACQUIRE_FENCES
        fence->Reset();
        VkFence fenceHandle = fence->GetHandle();
        #else
        VkFence fenceHandle = VK_NULL_HANDLE;
        #endif

        VkResult result; {
            const uint32_t maxImageIndex = val_array_size(imageAvailableSemaphore) - 1;
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

            while(imageIndex > maxImageIndex && (result == VK_SUCCESS || result == VK_SUBOPTIMAL_KHR)) {
                result = vkAcquireNextImageKHR(
                    device,
                    swapchain,
                    UINT64_MAX,
                    rawSemaphore,
                    fenceHandle,
                    &imageIndex
                );
            }
        }

        if(result == VK_ERROR_OUT_OF_DATE_KHR) {
            return (int32)SwapchainStatus::OUT_OF_DATE;
        }

        if(result == VK_ERROR_SURFACE_LOST_KHR) {
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
        }

        imageViews.clear();
    }

    void SwapchainVulkan::ReleaseImages() {
        for(int32 i=0; i<images.size(); i++) {
            vkDestroyImage(device, images[i], nullptr);
        }

        images.clear();
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

        if(swapchain != VK_NULL_HANDLE) {
            vkDestroySwapchainKHR(device, swapchain, nullptr);
            swapchain = VK_NULL_HANDLE;
        }

        // The front end will handle deleting the acquired fences and semaphores.
    }
}}