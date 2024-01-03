#include "../../../helpers/SpoopyHelpersVulkan.h"
#include "../GraphicsVulkan.h"
#include "SemaphoreVulkan.h"

#include <spoopy_assert.h>

namespace lime { namespace spoopy {
    SemaphoreVulkan::SemaphoreVulkan(const LogicalDevice &device):
    GPUResource(device),
    semaphore(handle) {
        semaphore = VK_NULL_HANDLE;
        semaphoreInfo.sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;
        Create();
    }

    void SemaphoreVulkan::Create() {
        checkVulkan(vkCreateSemaphore(device, &semaphoreInfo, nullptr, &semaphore));
    }

    void SemaphoreVulkan::Destroy() {
        SP_ASSERT(semaphore != VK_NULL_HANDLE);
        vkDestroySemaphore(device, semaphore, nullptr);
        semaphore = VK_NULL_HANDLE;
    }
}}