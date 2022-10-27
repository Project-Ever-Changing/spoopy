#include <device/SurfaceDevice.h>

#include <ui/Window.h>
#include <device/InstanceDevice.h>
#include <device/LogicalDevice.h>
#include <device/PhysicalDevice.h>

namespace spoopy {
    SurfaceDevice::SurfaceDevice(const InstanceDevice &instance, const PhysicalDevice &physical, const LogicalDevice &logical, const Window &window):
    instance(instance),
	physical(physical),
	logical(logical),
	window(window) {
        #ifdef SPOOPY_VULKAN
        window.createWindowSurfaceVulkan(instance.getInstance(), &surface);
        #endif
    }

    SurfaceDevice::~SurfaceDevice() {

    }
}