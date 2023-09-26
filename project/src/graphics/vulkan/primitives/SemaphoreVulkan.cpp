#include "../../../helpers/SpoopyHelpersVulkan.h"
#include "../GraphicsVulkan.h"
#include "SemaphoreVulkan.h"

#include <spoopy_assert.h>

namespace lime { namespace spoopy {
    SemaphoreVulkan::SemaphoreVulkan(const LogicalDevice &device, ContextVulkan &context):
    context(context) {
        VkSemaphoreCreateInfo semaphoreInfo = {};
        semaphoreInfo.sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;
        checkVulkan(vkCreateSemaphore(device, &semaphoreInfo, nullptr, &semaphore));
    }

    SemaphoreVulkan::~SemaphoreVulkan() {
        SP_ASSERT(semaphore != VK_NULL_HANDLE);
    }
}}
