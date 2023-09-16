#pragma once

#include <core/Log.h>
#include <spoopy.h>

#include <memory>
#include <utility>
#include <vector>

namespace lime { namespace spoopy {
    #ifdef LIME_VULKAN

    class SwapchainVulkan;
    class PhysicalDevice;
    class LogicalDevice;
    class CommandBufferVulkan;
    class QueueVulkan;
    class ContextStage;
    class Surface;

    class ContextVulkan {
        public:
            friend class GraphicsHandler;

            ContextVulkan(const std::shared_ptr<QueueVulkan> &queue);
            ~ContextVulkan();

            void RecreateSwapchain(const PhysicalDevice &physicalDevice, const LogicalDevice &logicalDevice, const VkExtent2D &extent, const SwapchainVulkan* oldSwapchain);
            VkResult AcquireNextImage(const VkSemaphore &presentCompleteSemaphore = VK_NULL_HANDLE, VkFence fence = VK_NULL_HANDLE);

            uint32_t GetImageCount() const;

            template<typename... Args> void CreateSurface(Args&&... args) { this->surface = std::make_unique<Surface>(std::forward<Args>(args)...); }
            void SetVSYNC(uint8_t sync) { this->sync = sync; }

            Surface* GetSurface() const { return surface.get(); }
            SwapchainVulkan* GetSwapchain() const { return swapchain.get(); }

            void DestroySwapchain();

            std::unique_ptr<ContextStage> stage;

        private:
            uint8_t sync = 0;

            std::unique_ptr<Surface> surface;
            std::unique_ptr<SwapchainVulkan> swapchain;
            std::shared_ptr<QueueVulkan> queue;
    };

    #endif
}}