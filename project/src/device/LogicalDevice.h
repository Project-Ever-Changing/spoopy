#pragma once

#include <graphics/Limits.h>
#include <spoopy.h>

#include <thread>
#include <memory>
#include <map>
#include <vector>

namespace lime { namespace spoopy {
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

            VkQueue GetQueue(const VkQueueFlagBits queueFamilyIndex) const;

            const VkDevice &GetLogicalDevice() const { return logicalDevice; }
            const VkPhysicalDeviceFeatures &GetEnabledFeatures() const { return enabledFeatures; }

            static const std::vector<const char *> Extensions;

            void SetupPresentQueue(const Surface &surface);

        private:
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