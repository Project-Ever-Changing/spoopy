#include <device/LogicalDevice.h>

namespace spoopy {
    LogicalDevice::LogicalDevice(const InstanceDevice &instance, const PhysicalDevice &physical):
    instance(instance), physical(physical) {
        //empty
    }

    LogicalDevice::~LogicalDevice() {
        
    }
}