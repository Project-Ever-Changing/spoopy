#pragma once

namespace lime {
    class PipelineVulkan {
        public:
            PipelineVulkan() = default;
            virtual ~PipelineVulkan() = default;

            operator const VkPipeline &() const { return pipeline; }

            const VkPipeline &GetPipeline() const { return pipeline; }
            const VkPipelineLayout &GetPipelineLayout() const { return pipelineLayout; }
            const VkPipelineBindPoint &GetPipelineBindPoint() const { return pipelineBindPoint; }

        protected:
            VkPipeline pipeline = VK_NULL_HANDLE;
            VkPipelineLayout pipelineLayout = VK_NULL_HANDLE;
            VkPipelineBindPoint pipelineBindPoint;
    };
}
