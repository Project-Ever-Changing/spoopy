#ifndef SPOOPY_SURFACE_DEVICE_H
#define SPOOPY_SURFACE_DEVICE_H

#include <core/Log.h>
#include <device/Devices.h>
#include <SpoopyHelpers.h>

namespace spoopy {
    class InstanceDevice;
    class LogicalDevice;
    class PhysicalDevice;
    class Window;

    class SurfaceDevice {
        public:
            explicit SurfaceDevice(const InstanceDevice &instance, const PhysicalDevice &physical, const LogicalDevice &logical, const Window &window);
            ~SurfaceDevice();
        private:
            const InstanceDevice &instance;
            const PhysicalDevice &physical;
            const LogicalDevice &logical;
            const Window &window;

            #ifdef SPOOPY_VULKAN
            VkSurfaceKHR surface = VK_NULL_HANDLE;
            VkSurfaceCapabilitiesKHR capabilities = {};
            VkSurfaceFormatKHR format = {};
            #endif
    };
}
#endif