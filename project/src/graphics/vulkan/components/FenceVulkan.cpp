#include "../../../device/LogicalDevice.h"
#include "../../../helpers/SpoopyHelpersVulkan.h"
#include "FenceVulkan.h"

#include <spoopy_assert.h>

namespace lime { namespace spoopy {
    FenceVulkan::FenceVulkan(const LogicalDevice &device, bool signaled)
    : GPUResource(device)
    , fence(handle)
    , signaled(signaled) {
        VkFenceCreateInfo fenceInfo = {};
        fenceInfo.sType = VK_STRUCTURE_TYPE_FENCE_CREATE_INFO;
        fenceInfo.flags = signaled ? VK_FENCE_CREATE_SIGNALED_BIT : 0;

        checkVulkan(vkCreateFence(device, &fenceInfo, nullptr, &fence));
    }

    void FenceVulkan::Destroy() {
        SP_ASSERT(fence != VK_NULL_HANDLE);
        vkDestroyFence(device, fence, nullptr);
        fence = VK_NULL_HANDLE;
    }

    bool FenceVulkan::Wait(uint64_t nanoseconds) {
        SP_ASSERT(!signaled);

        VkResult result = vkWaitForFences(device, 1, &fence, VK_TRUE, nanoseconds);
        if(result == VK_SUCCESS) {
            signaled = true;
            return false;
        }

        checkVulkan(result);
        return true;
    }

    void FenceVulkan::Reset() {
        if(!signaled) return;

        vkResetFences(device, 1, &fence);
        signaled = false;
    }
}}