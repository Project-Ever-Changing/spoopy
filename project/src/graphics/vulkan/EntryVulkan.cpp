#include "CommandBufferVulkan.h"
#include "EntryVulkan.h"
#include "QueueVulkan.h"

namespace lime { namespace spoopy {
    EntryVulkan::EntryVulkan(QueueVulkan &queue)
    : lastSubmittedCommandBuffer(nullptr) {
        queue.GetLastSubmittedInfo(lastSubmittedCommandBuffer, lastSubmittedCmdBufferFenceCounter);
    }

    EntryVulkan::~EntryVulkan() {
        lastSubmittedCommandBuffer = nullptr;
    }

    bool EntryVulkan::IsGPUOperationComplete() {
        if (lastSubmittedCommandBuffer == nullptr) {
            return true;
        }

        return lastSubmittedCmdBufferFenceCounter < lastSubmittedCommandBuffer->GetFenceSignaledCounter();
    }
}}