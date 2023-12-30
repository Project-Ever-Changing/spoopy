#pragma once

#include <graphics/GPUResource.h>

namespace lime { namespace spoopy {
    class LogicalDevice;

    class FenceVulkan: public GPUResource<VkFence> {
        public:
            explicit FenceVulkan(const LogicalDevice &device, bool signaled);
            ~FenceVulkan();

            bool Wait(uint64_t nanoseconds);
            void Reset();

        void SetSignaled(bool signaled) { this->signaled = signaled; }

        private:
            VkFence &fence;
            bool signaled;
    };
}}