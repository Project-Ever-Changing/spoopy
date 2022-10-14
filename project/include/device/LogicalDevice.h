#ifndef SPOOPY_LOGICAL_DEIVCE_H
#define SPOOPY_LOGICAL_DEIVCE_H

#include <vector>

#include <core/Log.h>
#include <device/Devices.h>

/*
* Families
*/
#include <families/QueueFamilyIndices.h>

namespace spoopy {
    class InstanceDevice;
    class PhysicalDevice;

    class LogicalDevice {
        public:
            explicit LogicalDevice(const InstanceDevice &instance, const PhysicalDevice &physical);
            virtual ~LogicalDevice();

            virtual void initDevice();
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
#endif