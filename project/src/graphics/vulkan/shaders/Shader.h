#pragma once

#include <utils/Bytes.h>
#include <spoopy.h>

namespace lime { namespace spoopy {
    class LogicalDevice;

    class Shader {
        public:
            Shader(const LogicalDevice &device, Bytes bytes, VkShaderStageFlagBits stage);
            VkPipelineShaderStageCreateInfo GetStageInfo() const { return stageInfo; }

        private:
            void CreateModule(Bytes bytes);
            void CreateStageInfo(VkShaderStageFlagBits stage);

        private:
            const LogicalDevice &device;

            VkShaderModule shaderModule;
            VkPipelineShaderStageCreateInfo stageInfo;
    };
}}