#ifndef SPOOPY_PHYSICAL_DEVICE_H
#define SPOOPY_PHYSICAL_DEVICE_H

#include <vector>

#include <SpoopyHelpers.h>

namespace spoopy {
    class InstanceDevice;

    class PhysicalDevice {
        public:
            explicit PhysicalDevice(const InstanceDevice &instance);

            #ifdef SPOOPY_VULKAN
            virtual const VkPhysicalDevice &getPhysicalDevice() const;
            #endif
        private:
            #ifdef SPOOPY_VULKAN
            VkPhysicalDevice physicalDevice = VK_NULL_HANDLE;
            #endif
    };
}
#endif