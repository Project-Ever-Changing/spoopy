#include <device/LogicalDevice.h>
#include <device/InstanceDevice.h>
#include <device/PhysicalDevice.h>

namespace spoopy {
    LogicalDevice::LogicalDevice(const InstanceDevice &instance, const PhysicalDevice &physical):
    instance(instance), physical(physical) {
        uint32_t deviceQueueFamilyPropertyCount;

        #ifdef SPOOPY_VULKAN
        vkGetPhysicalDeviceQueueFamilyProperties(physical.getPhysicalDevice(), &deviceQueueFamilyPropertyCount, nullptr);
        std::vector<VkQueueFamilyProperties> deviceQueueFamilyProperties(deviceQueueFamilyPropertyCount);
        vkGetPhysicalDeviceQueueFamilyProperties(physical.getPhysicalDevice(), &deviceQueueFamilyPropertyCount, deviceQueueFamilyProperties.data());

        queueFamily = new QueueFamilyIndices(deviceQueueFamilyProperties);
        #endif
    }

    LogicalDevice::~LogicalDevice() {
        if(queueFamily != nullptr) {
            delete queueFamily;
        }
    }
}