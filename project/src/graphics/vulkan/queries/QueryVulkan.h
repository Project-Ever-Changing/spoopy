#pragma once

#include <graphics/GPUResource.h>
#include <spoopy.h>

/*
 * TODO: Not going to be using this rn, but I'll keep it here for reference in the future.
 */
namespace lime { namespace spoopy {
    class LogicalDevice;
    class CommandBufferVulkan;

    struct Range {
        uint32_t start;
        uint32_t end;
    };

    class QueryPoolVulkan: public GPUResource<VkQueryPool, LogicalDevice> {
        public:
            QueryPoolVulkan(LogicalDevice &device, CommandBufferVulkan* cmdBuffer, uint32_t capacity, VkQueryType type);
            ~QueryPoolVulkan();

            void Reset(CommandBufferVulkan* cmdBuffer, uint32_t start, uint32_t end);
            bool GetResults(uint32_t index, uint64_4 &count);

            inline uint64_t GetResult(uint32_t index) const {
                return queryData[index];
            }

        protected:
            VkEvent resetEvent;
            std::vector<uint64_t> queryData;
    };
}}
