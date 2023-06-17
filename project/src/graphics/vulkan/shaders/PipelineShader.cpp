#include "PipelineShader.h"

namespace lime { namespace spoopy {
    PipelineShader::~PipelineShader() {
        stageInfos.clear();

        for (auto& shader: shaders) {
            shader.reset();
        }

        shaders.clear();
    }

    void PipelineShader::CreateShaderPipeline() {
        stageInfos.reserve(shaders.size());

        for (auto& shader: shaders) {
            stageInfos.push_back(shader->GetStageInfo());
        }
    }

    void PipelineShader::CreateVertexShader(Bytes bytes) {
        shaders.push_back(std::unique_ptr<Shader>(new Shader(device, bytes, VK_SHADER_STAGE_VERTEX_BIT)));
    }

    void PipelineShader::CreateFragmentShader(Bytes bytes) {
        shaders.push_back(std::unique_ptr<Shader>(new Shader(device, bytes, VK_SHADER_STAGE_FRAGMENT_BIT)));
    }

    void PipelineShader::CreateGeometryShader(Bytes bytes) {
        shaders.push_back(std::unique_ptr<Shader>(new Shader(device, bytes, VK_SHADER_STAGE_GEOMETRY_BIT)));
    }

    void PipelineShader::CreateTessellationControlShader(Bytes bytes) {
        shaders.push_back(std::unique_ptr<Shader>(new Shader(device, bytes, VK_SHADER_STAGE_TESSELLATION_CONTROL_BIT)));
    }

    void PipelineShader::CreateTessellationEvaluationShader(Bytes bytes) {
        shaders.push_back(std::unique_ptr<Shader>(new Shader(device, bytes, VK_SHADER_STAGE_TESSELLATION_EVALUATION_BIT)));
    }
}}