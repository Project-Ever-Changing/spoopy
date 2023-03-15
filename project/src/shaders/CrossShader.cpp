/*
* All rights are reserved to Alain Galvan.
* https://github.com/alaingalvan/CrossShader
* 
* Modified by Feeshy
*/

#include <utility>
#include <vector>

#include <shaders/CrossShader.h>

namespace lime {
    std::string compile(const char* source, ShaderFormat outputFormat) {

        // ⬇️ Input Compilation
        std::vector<uint32_t> spirvSource;

        size_t spirvSize = strlen(source);

        spirvSource.resize(spirvSize / 4);
        memcpy(spirvSource.data(), source, spirvSize);

        // ⬆️ Output Transpliation

        if(outputFormat == ShaderFormat::HLSL) {
            spirv_cross::CompilerHLSL hlsl(spirvSource);
            spirv_cross::CompilerHLSL::Options hlslOptions;
            hlslOptions.shader_model = 500;
            hlsl.set_hlsl_options(hlslOptions);
            return hlsl.compile();
        }else if(outputFormat == ShaderFormat::MSL) {
            spirv_cross::CompilerMSL msl(spirvSource);
            return msl.compile();
        }else if(outputFormat == ShaderFormat::SPIRV) {
            std::stringstream result;
            std::copy(spirvSource.begin(), spirvSource.end(),
                    std::ostream_iterator<uint32_t>(result, " "));
            return result.str().c_str();
        }

        return "";
    }

    #ifdef EMSCRIPTEN

    #include <emscripten/bind.h>

    EMSCRIPTEN_BINDINGS(cross_shader)
    {
        emscripten::enum_<xsdr::ShaderFormat>("ShaderFormat")
            .value("GLSL", xsdr::ShaderFormat::GLSL)
            .value("HLSL", xsdr::ShaderFormat::HLSL)
            .value("MSL", xsdr::ShaderFormat::MSL)
            .value("SPIRV", xsdr::ShaderFormat::SPIRV)
            .value("ShaderFormatMax", xsdr::ShaderFormat::ShaderFormatMax);

        emscripten::enum_<xsdr::ShaderStage>("ShaderStage")
            .value("Vertex", xsdr::ShaderStage::Vertex)
            .value("TessControl", xsdr::ShaderStage::TessControl)
            .value("TessEvaluation", xsdr::ShaderStage::TessEvaluation)
            .value("Geometry", xsdr::ShaderStage::Geometry)
            .value("Fragment", xsdr::ShaderStage::Fragment)
            .value("Compute", xsdr::ShaderStage::Compute)
            .value("ShaderStageMax", xsdr::ShaderStage::ShaderStageMax);

        emscripten::value_object<xsdr::InputOptions>("InputOptions")
            .field("format", &xsdr::InputOptions::format)
            .field("stage", &xsdr::InputOptions::stage)
            .field("glslVersion", &xsdr::InputOptions::glslVersion)
            .field("es", &xsdr::InputOptions::es);

        emscripten::value_object<xsdr::OutputOptions>("OutputOptions")
            .field("format", &xsdr::OutputOptions::format)
            .field("glslVersion", &xsdr::OutputOptions::glslVersion)
            .field("es", &xsdr::OutputOptions::es);

        emscripten::function("compile", &xsdr::compile);
    }
    
    #endif
}