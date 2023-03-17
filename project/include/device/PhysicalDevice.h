#pragma once

#include <vector>
#include <map>

#include <helpers/SpoopyHelpers.h>
#include <core/Log.h>

namespace lime {
    class InstanceDevice;

    class PhysicalDevice {
        public:
            PhysicalDevice(const InstanceDevice &instance);

            #ifdef SPOOPY_VULKAN
            virtual VkPhysicalDevice getSuitablePhysical(const std::vector<VkPhysicalDevice> &physicalDevices);
            virtual uint32_t scoreDeviceSuitability(VkPhysicalDevice device);

            virtual const VkPhysicalDevice &getPhysicalDevice() const {return physicalDevice;}
            virtual const VkPhysicalDeviceFeatures &getFeatures() const {return features;}
            #endif
        private:
            #ifdef SPOOPY_VULKAN
            VkPhysicalDevice physicalDevice = VK_NULL_HANDLE;
            VkPhysicalDeviceProperties properties = {};
            VkPhysicalDeviceFeatures features = {};
            VkPhysicalDeviceMemoryProperties memoryProperties = {};
            VkSampleCountFlagBits sampleCountBits = VK_SAMPLE_COUNT_1_BIT;
            #endif
    };
}