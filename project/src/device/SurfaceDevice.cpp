#include <device/SurfaceDevice.h>

#include <ui/SpoopyWindow.h>
#include <device/InstanceDevice.h>
#include <device/LogicalDevice.h>
#include <device/PhysicalDevice.h>

namespace spoopy {
    SurfaceDevice::SurfaceDevice(const InstanceDevice &instance, const PhysicalDevice &physical, const LogicalDevice &logical, const SpoopyWindow &window):
    instance(instance),
	physical(physical),
	logical(logical),
	window(window) {
        #ifdef SPOOPY_VULKAN
        window.createWindowSurfaceVulkan(instance.getInstance(), &surface);

        checkVulkan(vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physical.getPhysicalDevice(), surface, &capabilities));

        uint32_t surface_formatCount = 0;
        vkGetPhysicalDeviceSurfaceFormatsKHR(physical.getPhysicalDevice(), surface, &surface_formatCount, nullptr);
        std::vector<VkSurfaceFormatKHR> surfaceFormats(surface_formatCount);
        vkGetPhysicalDeviceSurfaceFormatsKHR(physical.getPhysicalDevice(), surface, &surface_formatCount, surfaceFormats.data());

        if(surface_formatCount == 1 && surfaceFormats[0].format == VK_FORMAT_UNDEFINED) {
            format.format = VK_FORMAT_B8G8R8A8_UNORM;
            format.colorSpace = surfaceFormats[0].colorSpace;
        } else {
            bool FOUND_FORMAT_B8G8R8A8_UNORM = false;

            for(auto &surfaceFormat: surfaceFormats) {
                if(surfaceFormat.format == VK_FORMAT_B8G8R8A8_UNORM) {
                    format.format = surfaceFormat.format;
                    format.colorSpace = surfaceFormat.colorSpace;
                    FOUND_FORMAT_B8G8R8A8_UNORM = true;
                    break;
                }
            }

            if (!FOUND_FORMAT_B8G8R8A8_UNORM) {
                format.format = surfaceFormats[0].format;
                format.colorSpace = surfaceFormats[0].colorSpace;
            }
        }

        VkBool32 presentSupport;
	    vkGetPhysicalDeviceSurfaceSupportKHR(physical.getPhysicalDevice(), logical.GetPresentFamily(), surface, &presentSupport);

        if (!presentSupport) {
		    throw std::runtime_error("Present queue family does not have presentation support!");
        }
        #endif
    }

    SurfaceDevice::~SurfaceDevice() {
        #ifdef SPOOPY_VULKAN
        vkDestroySurfaceKHR(instance.getInstance(), surface, nullptr);
        #endif
    }
}