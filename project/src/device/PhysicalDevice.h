#pragma once

#include <spoopy.h>

#include <vector>
#include <map>

namespace lime { namespace spoopy {
    class Instance;

    class PhysicalDevice {
        public:
            PhysicalDevice(const Instance &instance);

            inline VkPhysicalDevice GetPhysicalDevice() const { return physicalDevice; }

            const VkPhysicalDeviceProperties &GetProperties() const { return properties; }
            const VkPhysicalDeviceFeatures &GetFeatures() const { return features; }
            const VkPhysicalDeviceMemoryProperties &GetMemoryProperties() const { return memoryProperties; }
            const VkSampleCountFlagBits &GetMsaaSamples() const { return msaaSamples; }

            VkSampleCountFlagBits GetMaxUsableSampleCount() const;

        private:
            VkPhysicalDevice BestPhysicalDevice(const std::vector<VkPhysicalDevice> &devices);
            static uint32_t ScorePhysicalDevice(const VkPhysicalDevice &device);

        private:
            VkPhysicalDevice physicalDevice = VK_NULL_HANDLE;
            VkPhysicalDeviceProperties properties = {};
            VkPhysicalDeviceFeatures features = {};
            VkPhysicalDeviceMemoryProperties memoryProperties = {};
            VkSampleCountFlagBits msaaSamples = VK_SAMPLE_COUNT_1_BIT;

            const Instance &instance;
    };
}}
