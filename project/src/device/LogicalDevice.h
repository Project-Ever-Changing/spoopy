#pragma once

#include <system/Mutex.h>
#include <graphics/ContextLayer.h>
#include <graphics/Limits.h>
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

            static const std::vector<const char *> Extensions;

            void SetupPresentQueue(const Surface &surface);
            void WaitForGPU();

        public:
            Mutex fenceMutex;

        private:
            friend class GraphicsVulkan;

            void CreateLogicalDevice();
            void RegisterDeviceLimits();

            const Instance &instance;
            const PhysicalDevice &physicalDevice;

            std::shared_ptr<QueueVulkan> queues[4];
            Limits limits = {};

            VkDevice logicalDevice = VK_NULL_HANDLE;
            VkDeviceCreateInfo deviceCreateInfo = {};
            VkPhysicalDeviceFeatures enabledFeatures = {};
    };
}}