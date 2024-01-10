#pragma once

#ifdef SPOOPY_SDL
#include <SDL.h>
#endif

#include <system/Mutex.h>
#include <system/ValuePointer.h>
#include <core/Log.h>
#include <spoopy.h>

#include <memory>
#include <utility>
#include <vector>

namespace lime { namespace spoopy {
    #ifdef LIME_VULKAN

    class SemaphoreVulkan;
    class SwapchainVulkan;
    class PhysicalDevice;
    class LogicalDevice;
    class CommandBufferVulkan;
    class QueueVulkan;
    class ContextStage;
    class Surface;

    #ifdef SPOOPY_SDL
    using RAW_Window = SDL_Window;
    #endif

    class ContextVulkan {
        public:
            friend class GraphicsHandler;

            ContextVulkan(const std::shared_ptr<QueueVulkan> &queue);
            ~ContextVulkan();

            uint32_t GetImageCount() const;

            Surface* CreateSurface(LogicalDevice &device, PhysicalDevice &physicalDevice, RAW_Window* window) const;


            void SetVSYNC(bool sync) { this->vsync = sync; }

            SwapchainVulkan* GetSwapchain() const { return swapchain; }
            std::shared_ptr<QueueVulkan> GetQueue() const { return queue; }
            bool RecreateSwapchainWrapper(int width, int height);
            void InitSwapchain(int32 width, int32 height, RAW_Window* m_window, PhysicalDevice &physicalDevice);
            int PresentImageSwapchain(QueueVulkan* queue, SemaphoreVulkan* waitSemaphore);
            void CreateSwapchain(RAW_Window* m_window);
            void DestroySwapchain();

            std::unique_ptr<ContextStage> stage;

            VkPipelineStageFlags sourceStage = 0;
            VkPipelineStageFlags destStage = 0;

            ValuePointer* coreRecreateSwapchain;

            Mutex swapchainMutex;

        private:
            bool vsync;
            SwapchainVulkan* swapchain;
            VkSwapchainKHR oldSwapchain;

            std::shared_ptr<QueueVulkan> queue;
    };

    #endif
}}