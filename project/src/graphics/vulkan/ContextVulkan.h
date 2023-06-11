#pragma once

#include "CommandBufferVulkan.h"

#include <sdl_definitions_config.h>
#include <core/Log.h>

#include <memory>
#include <vector>

namespace lime { namespace spoopy {
    class Surface;
    class SwapchainVulkan;
    class PhysicalDevice;
    class LogicalDevice;

    class ContextVulkan: public ContextBase {
        private:
            struct SurfaceBuffer {
                std::vector<VkSemaphore> presentCompletes;
                std::vector<VkSemaphore> renderCompletes;
                std::vector<VkFence> flightFences;
                std::size_t currentFrame = 0;
                bool framebufferResized = false;

                std::vector<std::unique_ptr<CommandBufferVulkan>> commandBuffers;
            };

        public:
            friend class GraphicsHandler;

            ContextVulkan();
            ~ContextVulkan();

            void RecreateSwapchain(const PhysicalDevice &physicalDevice, const LogicalDevice &logicalDevice, const VkExtent2D &extent, const SwapchainVulkan* oldSwapchain);
            void RecreateCommandBuffers(const LogicalDevice &logicalDevice);
            VkResult AcquireNextImage(const VkSemaphore &presentCompleteSemaphore = VK_NULL_HANDLE, VkFence fence = VK_NULL_HANDLE);

            uint32_t GetImageCount() const;

            void SetSurface(std::unique_ptr<Surface> surface);
            void SetVSYNC(uint8_t sync) { this->sync = sync; }

            SurfaceBuffer* GetSurfaceBuffer() const { return surfaceBuffer.get(); }
            SwapchainVulkan* GetSwapchain() const { return swapchain.get(); }

            void DestroySwapchain();

        private:
            uint8_t sync = 0;

            std::unique_ptr<Surface> surface;
            std::unique_ptr<SwapchainVulkan> swapchain;
            std::unique_ptr<SurfaceBuffer> surfaceBuffer;
    };
}}