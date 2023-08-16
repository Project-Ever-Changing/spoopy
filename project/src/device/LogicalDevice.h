#pragma once

#include <graphics/Limits.h>
#include <spoopy.h>

#include <thread>
#include <memory>
#include <map>
#include <vector>

namespace lime { namespace spoopy {
    class CommandPoolVulkan;
    class PhysicalDevice;
    class Instance;

    class LogicalDevice {
        public:
            LogicalDevice(const Instance &instance, const PhysicalDevice &physicalDevice);
            ~LogicalDevice();

            operator const VkDevice &() const { return logicalDevice; }

            VkQueue GetQueue(const VkQueueFlagBits queueFamilyIndex) const;

            const VkDevice &GetLogicalDevice() const { return logicalDevice; }
            const VkPhysicalDeviceFeatures &GetEnabledFeatures() const { return enabledFeatures; }
            const VkQueue &GetGraphicsQueue() const { return graphicsQueue; }
            const VkQueue &GetPresentQueue() const { return presentQueue; }
            const VkQueue &GetComputeQueue() const { return computeQueue; }
            const VkQueue &GetTransferQueue() const { return transferQueue; }
            uint32_t GetGraphicsFamily() const { return graphicsFamily; }
            uint32_t GetPresentFamily() const { return presentFamily; }
            uint32_t GetComputeFamily() const { return computeFamily; }
            uint32_t GetTransferFamily() const { return transferFamily; }

            const std::shared_ptr<CommandPoolVulkan> &GetGraphicsCommandPool(const std::thread::id &threadId = std::this_thread::get_id());

            static const std::vector<const char *> Extensions;

        private:
            void CreateQueueIndices();
            void CreateLogicalDevice();
            void RegisterDeviceLimits();

            const Instance &instance;
            const PhysicalDevice &physicalDevice;

            Limits limits = {};

            VkDevice logicalDevice = VK_NULL_HANDLE;
            VkPhysicalDeviceFeatures enabledFeatures = {};

            VkQueueFlags supportedQueues = {};
            uint32_t graphicsFamily = 0;
            uint32_t presentFamily = 0;
            uint32_t computeFamily = 0;
            uint32_t transferFamily = 0;

            VkQueue graphicsQueue = VK_NULL_HANDLE;
            VkQueue presentQueue = VK_NULL_HANDLE;
            VkQueue computeQueue = VK_NULL_HANDLE;
            VkQueue transferQueue = VK_NULL_HANDLE;

            std::map<std::thread::id, std::shared_ptr<CommandPoolVulkan>> graphicsCommandPools;
    };
}}
