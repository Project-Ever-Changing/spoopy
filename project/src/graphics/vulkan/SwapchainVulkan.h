#pragma once

#include "../../device/Surface.h"

#include <SDL.h>
#include <graphics/GPUResource.h>
#include <graphics/Swapchain.h>
#include <system/CFFI.h>

#include <functional>

namespace lime { namespace spoopy {
    class PhysicalDevice;
    class LogicalDevice;
    class ContextVulkan;
    class FenceVulkan;
    class SemaphoreVulkan;
    class CommandBufferVulkan;

    #ifdef SPOOPY_SDL
    using RAW_Window = SDL_Window;
    #endif

    class SwapchainVulkan: public Swapchain {
        private:
            enum class SwapchainStatus {
                OK = 0,
                OUT_OF_DATE = -1,
                LOST_SURFACE = -2,
                OTHER = -3
            };

        public:
            SwapchainVulkan(int32 width, int32 height, RAW_Window* m_window, VkSwapchainKHR &oldSwapchain, bool vsync
            , LogicalDevice &device, PhysicalDevice &physicalDevice, const ContextVulkan &context);
            int32 AcquireNextImage(value imageAvailableSemaphore, FenceVulkan* fence
            , int32 prevSemaphoreIndex, int32 semaphoreIndex);
            SwapchainStatus Present(QueueVulkan* queue, SemaphoreVulkan* waitSemaphore);
            void Create(const VkSwapchainKHR &oldSwapchain, RAW_Window* m_window);
            void Destroy(VkSwapchainKHR &oldSwapchain);

            size_t GetImageCount() const { return images.size(); }
            VkFormat GetFormat() const { return surface->GetFormat().format; }

        private:
            void ReleaseImageViews();
            void ReleaseImages();

        private:
            bool vsync;

            LogicalDevice &device;
            PhysicalDevice &physicalDevice;

            std::vector<VkImage> images;
            std::vector<VkImageView> imageViews;

            int32 acquiredImageIndex;
            int32 currentImageIndex;

            VkSwapchainKHR swapchain;

            std::unique_ptr<Surface> surface;
    };
}}