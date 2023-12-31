#pragma once

#include <system/Mutex.h>
#include <system/ValuePointer.h>
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

            uint32_t GetImageCount() const;

            template<typename... Args> void CreateSurface(Args&&... args) { this->surface = std::make_unique<Surface>(std::forward<Args>(args)...); }
            void SetVSYNC(uint8_t sync) { this->sync = sync; }

            Surface* GetSurface() const { return surface.get(); }
            SwapchainVulkan* GetSwapchain() const;
            std::shared_ptr<QueueVulkan> GetQueue() const { return queue; }
            bool RecreateSwapchainWrapper(int width, int height);

            void DestroySwapchain();

            std::unique_ptr<ContextStage> stage;

            VkPipelineStageFlags sourceStage = 0;
            VkPipelineStageFlags destStage = 0;

            ValuePointer* coreRecreateSwapchain;

        private:
            uint8_t sync = 0;
            SwapchainVulkan* swapchain;
            VkSwapchainKHR oldSwapchain;

            std::unique_ptr<Surface> surface;
            std::shared_ptr<QueueVulkan> queue;

            Mutex swapchainMutex;
    };

    #endif
}}