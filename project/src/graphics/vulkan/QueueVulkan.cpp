#include "QueueVulkan.h"
#include "GraphicsVulkan.h"
#include "CommandBufferVulkan.h"
#include "components/FenceVulkan.h"

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

        int QueueVulkan::SubmitBuffer(CommandBufferVulkan* cmdBuffer, FenceVulkan* fence, value rawWaitSemaphores
        , int state, uint32_t numSignalSemaphores, VkSemaphore* signalSemaphores) {

        SP_ASSERT(state == 3); // 3 means that the command buffer `has ended` and is ready to be submitted
        SP_ASSERT(!fence->IsSignaled());

        const VkCommandBuffer cmdBufferHandles[] = {cmdBuffer->GetHandle()};

        VkSubmitInfo submitInfo = {};
        submitInfo.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;
        submitInfo.commandBufferCount = 1;
        submitInfo.pCommandBuffers = cmdBufferHandles;
        submitInfo.signalSemaphoreCount = numSignalSemaphores;
        submitInfo.pSignalSemaphores = signalSemaphores;

        const int rawWaitSemaphoresCapacity = val_array_size(rawWaitSemaphores);
        VkSemaphore waitSemaphores[rawWaitSemaphoresCapacity];

        for(int i=0; i<rawWaitSemaphoresCapacity; i++) {
            SemaphoreVulkan* semaphore = (SemaphoreVulkan*)val_data(val_array_i(rawWaitSemaphores, i));
            waitSemaphores[i] = semaphore->GetSemaphore();
        }

        submitInfo.waitSemaphoreCount = rawWaitSemaphoresCapacity;
        submitInfo.pWaitSemaphores = waitSemaphores;
        submitInfo.pWaitDstStageMask = cmdBuffer->waitDstStageMask.data();

        checkVulkan(vkQueueSubmit(queue, 1, &submitInfo, fence->GetFence()));

        return 1; // 1 means that the command buffer `is submitted` and is waiting to be executed
    }

    // TODO: Make a Submit2 method that supports multiple command buffers and semaphores with Vulkan 1.3
    // I do need to enable the VK_KHR_synchronization2 extension for it though
}}