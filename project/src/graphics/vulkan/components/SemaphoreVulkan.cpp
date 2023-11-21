#include "../../../helpers/SpoopyHelpersVulkan.h"
#include "../GraphicsVulkan.h"
#include "SemaphoreVulkan.h"

#include <spoopy_assert.h>

namespace lime { namespace spoopy {
    SemaphoreVulkan::SemaphoreVulkan(const LogicalDevice &device):
    BufferWrapper(device),
    semaphore(handle) {
        VkSemaphoreCreateInfo semaphoreInfo = {};
        semaphoreInfo.sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;
        checkVulkan(vkCreateSemaphore(device, &semaphoreInfo, nullptr, &semaphore));
    }

    SemaphoreVulkan::~SemaphoreVulkan() {
        SP_ASSERT(semaphore != VK_NULL_HANDLE);
        vkDestroySemaphore(device, semaphore, nullptr);
        semaphore = VK_NULL_HANDLE;
    }
}}
