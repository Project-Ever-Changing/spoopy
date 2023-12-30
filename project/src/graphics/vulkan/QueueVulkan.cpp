#include "QueueVulkan.h"
#include "GraphicsVulkan.h"
#include "CommandBufferVulkan.h"

namespace lime { namespace spoopy {
    QueueVulkan::QueueVulkan(LogicalDevice &device, uint32_t familyIndex)
    : device(device)
    , familyIndex(familyIndex)
    , queue(VK_NULL_HANDLE)
    , lastSubmittedCommandBuffer(nullptr),
      lastSubmittedCmdBufferFenceCounter(0) {
        vkGetDeviceQueue(device, familyIndex, 0, &queue);
    }

    void QueueVulkan::UpdateLastSubmittedCommandBuffer(CommandBufferVulkan* cmdBuffer) {
        mutex.Lock();

        lastSubmittedCommandBuffer = cmdBuffer;
        lastSubmittedCmdBufferFenceCounter = cmdBuffer->GetFenceSignaledCounter();

        mutex.Unlock();
    }

    void QueueVulkan::GetLastSubmittedInfo(CommandBufferVulkan*& cmdBuffer, uint64_t& fenceCounter) {
        mutex.Lock();

        cmdBuffer = lastSubmittedCommandBuffer;
        fenceCounter = lastSubmittedCmdBufferFenceCounter;

        mutex.Unlock();
    }
}}