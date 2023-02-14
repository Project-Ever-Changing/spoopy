#pragma once

#include <vector>

#include <core/Log.h>
#include <device/Devices.h>

/*
* Families
*/
#include <families/QueueFamilyIndices.h>

namespace lime {
    class InstanceDevice;
    class PhysicalDevice;

    class LogicalDevice {
        public:
            LogicalDevice(const InstanceDevice &instance, const PhysicalDevice &physical);
            virtual ~LogicalDevice();

            virtual void initDevice();

            uint32_t GetGraphicsFamily() const {return queueFamily -> graphicsFamily;}
            uint32_t GetPresentFamily() const {return queueFamily -> presentFamily;}
            uint32_t GetComputeFamily() const {return queueFamily -> computeFamily;}
            uint32_t GetTransferFamily() const {return queueFamily -> transferFamily;}
        private:
            QueueFamilyIndices* queueFamily;

            const InstanceDevice &instance;
            const PhysicalDevice &physical;

            #ifdef SPOOPY_VULKAN
            VkDevice logical = VK_NULL_HANDLE;
            VkPhysicalDeviceFeatures enabledFeatures = {};
            #endif
    };
}