#ifndef SPOOPY_LOGICAL_DEIVCE_H
#define SPOOPY_LOGICAL_DEIVCE_H

#include <device/Devices.h>

namespace spoopy {
    class InstanceDevice;
    class PhysicalDevice;

    class LogicalDevice {
        public:
            explicit LogicalDevice(const InstanceDevice &instance, const PhysicalDevice &physical);
            virtual ~LogicalDevice();
        private:
            const InstanceDevice &instance;
            const PhysicalDevice &physical;
    };
}
#endif