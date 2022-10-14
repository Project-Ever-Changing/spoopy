#include <device/Devices.h>

#ifdef SPOOPY_VULKAN
#include <SpoopyHelpers.h>
#endif

namespace spoopy {
    #ifdef SPOOPY_VULKAN
    const std::vector<const char*> Devices::Extensions = {VK_KHR_SWAPCHAIN_EXTENSION_NAME};
    #else
    const std::vector<const char*> Devices::Extensions = {};
    #endif
}