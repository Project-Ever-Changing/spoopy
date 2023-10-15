#include "../../../helpers/SpoopyHelpersVulkan.h"
#include "../GraphicsVulkan.h"
#include "SemaphoreVulkan.h"

#include <spoopy_assert.h>

namespace lime { namespace spoopy {
    SemaphoreVulkan::SemaphoreVulkan(const LogicalDevice &device):
    device(device),
    semaphore(VK_NULL_HANDLE) {
        VkSemaphoreCreateInfo semaphoreInfo = {};
        semaphoreInfo.sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;
        checkVulkan(vkCreateSemaphore(device, &semaphoreInfo, nullptr, &semaphore));
    }

    void SemaphoreVulkan::Destroy() {
        if (semaphore != VK_NULL_HANDLE) {
            vkDestroySemaphore(device, semaphore, nullptr);
            semaphore = VK_NULL_HANDLE;
        }
    }
}}
