#pragma once

#include "Shader.h"

#include <vector>
#include <memory>

namespace lime { namespace spoopy {
    class PipelineShader {
        public:
            PipelineShader(const LogicalDevice &device): device(device) {}
            ~PipelineShader();

            void CreateVertexShader(Bytes bytes);
            void CreateFragmentShader(Bytes bytes);
            void CreateGeometryShader(Bytes bytes);
            void CreateTessellationControlShader(Bytes bytes);
            void CreateTessellationEvaluationShader(Bytes bytes);
            void CreateShaderPipeline();

            const std::vector<VkPipelineShaderStageCreateInfo> &GetStageInfos() const { return stageInfos; }

        private:
            const LogicalDevice &device;

            std::vector<VkPipelineShaderStageCreateInfo> stageInfos;
            std::vector<std::unique_ptr<Shader>> shaders;
    };
}}