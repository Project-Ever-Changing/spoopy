#include <device/PhysicalDevice.h>
#include <device/InstanceDevice.h>

namespace spoopy {
    PhysicalDevice::PhysicalDevice(const InstanceDevice &instance) {
        #ifdef SPOOPY_VULKAN
        uint32_t physicalCount;

        vkEnumeratePhysicalDevices(instance.getInstance(), &physicalCount, nullptr);
        #endif
    }

    #ifdef SPOOPY_VULKAN
    const VkPhysicalDevice &PhysicalDevice::getPhysicalDevice() const {
        return physicalDevice;
    }
    #endif
}