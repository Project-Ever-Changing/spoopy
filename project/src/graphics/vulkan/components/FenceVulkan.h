#pragma once

#include <graphics/GPUResource.h>

namespace lime { namespace spoopy {
    class LogicalDevice;

    class FenceVulkan: public GPUResource<VkFence> {
        public:
            explicit FenceVulkan(const LogicalDevice &device, bool signaled);

            bool Wait(uint64_t nanoseconds);
            void Reset();

            /*
             * Seriously.. what is the point of this...Anyways
             */
            void SetSignaled(bool signaled) { this->signaled = signaled; }
            bool IsSignaled() const { return signaled; }
            VkFence &GetFence() { return fence; }

            void Destroy() override;

        private:
            VkFence &fence;
            bool signaled;
    };
}}