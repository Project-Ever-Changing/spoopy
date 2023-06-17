#pragma once

#include "Shader.h"

#include <vector>
#include <memory>

namespace lime { namespace spoopy {
    class PipelineShader {
        public:
            PipelineShader(VkDevice device): device(device) {}
            ~PipelineShader();

            void CreateVertexShader(Bytes bytes);
            void CreateFragmentShader(Bytes bytes);
            void CreateGeometryShader(Bytes bytes);
            void CreateTessellationControlShader(Bytes bytes);
            void CreateTessellationEvaluationShader(Bytes bytes);
            void CreateShaderPipeline();

        private:
            VkDevice device;

            std::vector<VkPipelineShaderStageCreateInfo> stageInfos;
            std::vector<std::unique_ptr<Shader>> shaders;
    };
}}