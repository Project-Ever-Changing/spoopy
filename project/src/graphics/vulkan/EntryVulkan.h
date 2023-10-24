#pragma once

#include <system/Mutex.h>

namespace lime { namespace spoopy {
    class CommandBufferVulkan;
    class QueueVulkan;

    class EntryVulkan {
        public:
            EntryVulkan(QueueVulkan &queue);

            bool IsGPUOperationComplete();

        private:
            CommandBufferVulkan* lastSubmittedCommandBuffer;
            uint64_t lastSubmittedCmdBufferFenceCounter;
    };
}}
