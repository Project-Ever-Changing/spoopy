#include "Shader.h"

namespace lime { namespace spoopy {
    Shader::Shader(VkDevice device, Bytes bytes, VkShaderStageFlagBits stage): device(device) {
        CreateModule(bytes);
    }

    void Shader::CreateModule(Bytes bytes) {
        VkShaderModuleCreateInfo createInfo = {};
        createInfo.sType = VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO;
        createInfo.codeSize = (uint32_t)bytes.length;
        createInfo.pCode = reinterpret_cast<const uint32_t*>(bytes.b);
        checkVulkan(vkCreateShaderModule(device, &createInfo, nullptr, &shaderModule));
    }

    void Shader::CreateStageInfo(VkShaderStageFlagBits stage) {
        stageInfo = {};
        stageInfo.sType = VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO;
        stageInfo.stage = stage;
        stageInfo.module = shaderModule;
        stageInfo.pName = "main";
        stageInfo.pSpecializationInfo = nullptr;
    }
}}