#include "QueueVulkan.h"
#include "GraphicsVulkan.h"


namespace lime { namespace spoopy {
    QueueVulkan::QueueVulkan(const LogicalDevice &device, uint32_t familyIndex)
    : device(device)
    , familyIndex(familyIndex)
    , queue(VK_NULL_HANDLE)
    , lastSubmittedCmdBuffer(nullptr) {
        vkGetDeviceQueue(device, familyIndex, 0, &queue);
    }

    void QueueVulkan::UpdateLastSubmittedCommandBuffer(CommandBufferVulkan* cmdBuffer) {
        mutex.Lock();

        lastSubmittedCommandBuffer = cmdBuffer;
        lastSubmittedCmdBufferFenceCounter = cmdBuffer->GetFenceSignaledCounter();

        mutex.Unlock();
    }
}}