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
        private:
            const QueueFamilyIndices* queueFamily;

            const InstanceDevice &instance;
            const PhysicalDevice &physical;
    };
}
#endif