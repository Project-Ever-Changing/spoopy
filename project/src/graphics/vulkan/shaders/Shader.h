#pragma once

#include "../../../helpers/SpoopyHelpersVulkan.h"

#include <utils/Bytes.h>

namespace lime { namespace spoopy {
    class Shader {
        public:
            Shader(VkDevice device, Bytes bytes, VkShaderStageFlagBits stage);
            VkPipelineShaderStageCreateInfo GetStageInfo() const { return stageInfo; }

        private:
            void CreateModule(Bytes bytes);
            void CreateStageInfo(VkShaderStageFlagBits stage);

            VkDevice device;
            VkShaderModule shaderModule;
            VkPipelineShaderStageCreateInfo stageInfo;
    };
}}