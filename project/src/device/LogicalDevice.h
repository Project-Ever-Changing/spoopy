#pragma once

#include <system/Mutex.h>
#include <graphics/ContextLayer.h>
#include <graphics/Limits.h>
#include <vk_mem_alloc.h>
#include <spoopy.h>

#include <thread>
#include <memory>
#include <map>
#include <vector>

namespace lime { namespace spoopy {
    class SwapchainVulkan;
    class QueueVulkan;
    class CommandPoolVulkan;
    class PhysicalDevice;
    class Instance;
    class Surface;

    class LogicalDevice {
        public:
            LogicalDevice(const Instance &instance, const PhysicalDevice &physicalDevice);
            ~LogicalDevice();

            operator const VkDevice &() const { return logicalDevice; }

            const VkDevice &GetLogicalDevice() const { return logicalDevice; }
            const VkPhysicalDeviceFeatures &GetEnabledFeatures() const { return enabledFeatures; }

            // TODO: Maybe expand a pon this? I mean, it's the reason why I switched it to be in logical device.
            ContextVulkan* CreateContextVulkan() {return new ContextVulkan(queues[0]);}

            static const std::vector<const char*> Extensions;

            void SetupPresentQueue(const Surface &surface);
            void WaitForGPU();

            QueueVulkan* GetGraphicsQueue() const { return queues[0].get(); }
            QueueVulkan* GetPresentQueue() const { return queues[3].get(); }

            VkResult CreateHostBuffer(uint32_t size, VkBuffer* buffer, VmaAllocation* allocation
            , VmaMemoryUsage usage = VMA_MEMORY_USAGE_AUTO_PREFER_HOST);

            bool FindInstanceExtensions(const char* extension) const;

        public:
            Mutex fenceMutex;

            /*
             * The Device's VMA Allocator. This is used to allocate memory for buffers and images.
             */
            VmaAllocator allocator;

            /*
             * The Device's Physical Device Limits.
             */
            VkPhysicalDeviceLimits physicalDeviceLimits;

        private:
            friend class GraphicsVulkan;

            void CreateLogicalDevice();
            void RegisterDeviceLimits();
            void CreateAllocator();

            const Instance &instance;
            const PhysicalDevice &physicalDevice;

            std::shared_ptr<QueueVulkan> queues[4];
            Limits limits = {};

            VkDevice logicalDevice = VK_NULL_HANDLE;
            VkDeviceCreateInfo deviceCreateInfo = {};
            VkPhysicalDeviceFeatures enabledFeatures = {};
    };
}}