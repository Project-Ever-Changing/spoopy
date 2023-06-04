#pragma once

#include <spoopy.h>

#include <vector>
#include <map>

namespace lime {
    class Instance;

    class PhysicalDevice {
        public:
            PhysicalDevice(const Instance &instance);

            operator const VkPhysicalDevice &() const { return physicalDevice; }

            const VkPhysicalDevice &GetPhysicalDevice() const { return physicalDevice; }
            const VkPhysicalDeviceProperties &GetProperties() const { return properties; }
            const VkPhysicalDeviceFeatures &GetFeatures() const { return features; }
            const VkPhysicalDeviceMemoryProperties &GetMemoryProperties() const { return memoryProperties; }
            const VkSampleCountFlagBits &GetMsaaSamples() const { return msaaSamples; }
        private:
            VkSampleCountFlagBits GetMaxUsableSampleCount();

            VkPhysicalDevice BestPhysicalDevice(const std::vector<VkPhysicalDevice> &devices);

            static uint32_t ScorePhysicalDevice(const VkPhysicalDevice &device);

            const Instance &instance;

            VkPhysicalDevice physicalDevice = VK_NULL_HANDLE;
            VkPhysicalDeviceProperties properties = {};
            VkPhysicalDeviceFeatures features = {};
            VkPhysicalDeviceMemoryProperties memoryProperties = {};
            VkSampleCountFlagBits msaaSamples = VK_SAMPLE_COUNT_1_BIT;
    };
}
