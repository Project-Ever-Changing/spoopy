#pragma once

#include <spoopy.h>

namespace lime { namespace spoopy {
    class LogicalDevice;

    enum PotentialQueueIndex : uint32_t {
        P_Graphics = 0,
        P_Compute = 1,
        P_Transfer = 2,
        P_Present = 3
    };

    class QueueVulkan {
        public:
            QueueVulkan(const LogicalDevice &device, uint32_t familyIndex);

            operator const VkQueue &() const { return queue; }
            const VkQueue &GetQueue() const { return queue; }
            const uint32_t &GetFamilyIndex() const { return familyIndex; }

        private:
            uint32_t familyIndex;
            VkQueue queue;

            const LogicalDevice &device;
    };
}}