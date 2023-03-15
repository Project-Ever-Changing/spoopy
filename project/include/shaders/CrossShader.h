/*
* All rights are reserved to Alain Galvan
* https://github.com/alaingalvan/CrossShader
* 
* Modified by Feeshy
*/

#pragma once

#ifndef NO_GLSLANG_INCLUDED

#include <SPIRV/GlslangToSpv.h>
#include <SPIRV/disassemble.h>
#include <glslang/Include/ResourceLimits.h>
#include <glslang/Public/ShaderLang.h>
#include <SPIRV/SPVRemapper.h>
#include <SPIRV/doc.h>

#endif

#include <spirv.hpp>
#include <spirv_cross.hpp>
#include <spirv_glsl.hpp>
#include <spirv_hlsl.hpp>
#include <spirv_msl.hpp>

#include <string>
#include <exception>
#include <stdexcept>
#include <ostream>
#include <iterator>
#include <sstream>

namespace lime {
    enum ShaderFormat {
        GLSL,
        HLSL,
        MSL,
        SPIRV,
        ShaderFormatMax
    };

    enum ShaderStage {
        Vertex,
        TessControl,
        TessEvaluation,
        Geometry,
        Fragment,
        Compute,
        ShaderStageMax
    };

    std::string compile(const char* source, ShaderFormat outputFormat);
}