#pragma once

#include <core/Log.h>
#include <device/Devices.h>
#include <helpers/SpoopyHelpers.h>

namespace lime {
    class InstanceDevice;
    class LogicalDevice;
    class PhysicalDevice;
    class SpoopyWindowSurface;

    class SurfaceDevice {
        public:
            SurfaceDevice(const InstanceDevice &instance, const PhysicalDevice &physical, const LogicalDevice &logical, const SpoopyWindowSurface &window);
            ~SurfaceDevice();
        private:
            const InstanceDevice &instance;
            const PhysicalDevice &physical;
            const LogicalDevice &logical;
            const SpoopyWindowSurface &window;

            #ifdef SPOOPY_VULKAN
            VkSurfaceKHR surface = VK_NULL_HANDLE;
            VkSurfaceCapabilitiesKHR capabilities = {};
            VkSurfaceFormatKHR format = {};
            #endif
    };
}