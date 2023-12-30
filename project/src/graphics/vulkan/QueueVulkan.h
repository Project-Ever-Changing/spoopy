#pragma once

#include <system/Mutex.h>
#include <spoopy.h>

namespace lime { namespace spoopy {
    class LogicalDevice;
    class CommandBufferVulkan;

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

            void GetLastSubmittedInfo(CommandBufferVulkan*& cmdBuffer, uint64_t& fenceCounter);
            //inline void Submit(value cmdBuffers, int count);

        private:
            void UpdateLastSubmittedCommandBuffer(CommandBufferVulkan* cmdBuffer);

            uint32_t familyIndex;
            Mutex mutex;
            VkQueue queue;

            LogicalDevice &device;

            CommandBufferVulkan* lastSubmittedCommandBuffer;
            uint64_t lastSubmittedCmdBufferFenceCounter;
    };
}}