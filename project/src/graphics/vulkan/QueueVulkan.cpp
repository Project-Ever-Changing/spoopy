#include "QueueVulkan.h"
#include "GraphicsVulkan.h"

namespace lime { namespace spoopy {
    QueueVulkan::QueueVulkan(const LogicalDevice &device, uint32_t familyIndex)
    : device(device)
    , familyIndex(familyIndex)
    , queue(VK_NULL_HANDLE) {
        vkGetDeviceQueue(device, familyIndex, 0, &queue);
    }
}}