#pragma once

#include "components/SemaphoreVulkan.h"

#include <system/Mutex.h>
#include <spoopy_assert.h>
#include <spoopy.h>

namespace lime { namespace spoopy {
    class LogicalDevice;
    class CommandBufferVulkan;
    class SemaphoreVulkan;
    class FenceVulkan;

    enum PotentialQueueIndex : uint32_t {
        P_Graphics = 0,
        P_Compute = 1,
        P_Transfer = 2,
        P_Present = 3
    };

    class QueueVulkan {
    public:
        QueueVulkan(LogicalDevice &device, uint32_t familyIndex);

        operator const VkQueue &() const { return queue; }

        const VkQueue &GetQueue() const { return queue; }

        const uint32_t &GetFamilyIndex() const { return familyIndex; }

        LogicalDevice &GetDevice() const { return device; }

        void GetLastSubmittedInfo(CommandBufferVulkan *&cmdBuffer, uint64_t &fenceCounter);

        private:
            int SubmitBuffer(CommandBufferVulkan* cmdBuffer, FenceVulkan* fence, value rawWaitSemaphores
            , int state, uint32_t numSignalSemaphores, VkSemaphore* signalSemaphores);
            void UpdateLastSubmittedCommandBuffer(CommandBufferVulkan* cmdBuffer);

            uint32_t familyIndex;
            Mutex mutex;
            VkQueue queue;

            LogicalDevice &device;

            CommandBufferVulkan* lastSubmittedCommandBuffer;
            uint64_t lastSubmittedCmdBufferFenceCounter;

        public:
            inline int Submit(CommandBufferVulkan* cmdBuffer, FenceVulkan* fence, value rawWaitSemaphores
            , const int state, SemaphoreVulkan &signalSemaphore) {
                return SubmitBuffer(cmdBuffer, fence, rawWaitSemaphores, state, 1, &signalSemaphore.GetSemaphore());
            }
    };
}}