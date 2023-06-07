#pragma once

#include "PipelineVulkan.h"
#include "shaders/VertexShaderInput.h"
#include "shaders/ShaderVulkan.h"

#include <vector>
#include <utility>

namespace lime { namespace spoopy {
    class GraphicsPipelineVulkan: public PipelineVulkan {
        public:
            enum class Mode {
                POLYGON, MRT
            };

            enum class Depth {
                NONE = 0,
                READ = 1,
                WRITE = 2,
                READWRITE = Read | Write
            };

            PipelineVulkan(PPosition position, const char** shaderPaths, std::vector<VertexShaderInput> vertexInputs, std::vector<Define> definitions = {},
                Mode mode = Mode::POLYGON, Depth depth = Depth::READWRITE, VkPrimitiveTopology topology = VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST, VkPolygonMode polygonMode = VK_POLYGON_MODE_FILL,
                VkCullModeFlags cullMode = VK_CULL_MODE_BACK_BIT, VkFrontFace frontFace = VK_FRONT_FACE_CLOCKWISE, bool pushDescriptors = false);
            ~PipelineVulkan();

        private:
            PPosition position;
    };
}