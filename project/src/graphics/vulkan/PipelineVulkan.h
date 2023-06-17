#pragma once

#include "../../helpers/SpoopyHelpersVulkan.h"
#include "VertexShaderInput.h"

#include <math/Rectangle.h>

/*
 * A general pipeline for both graphics and compute pipelines.
 */

namespace lime { namespace spoopy {
    class Shader;
    class PipelineShader;

    class PipelineVulkan {
        public:
            PipelineVulkan(VkDevice device): device(device);
            ~PipelineVulkan();

            void CreateGraphicsPipeline(std::unique_ptr<PipelineShader> pipeline, VkRenderPass renderPass);

            void SetVertexInput(VertexShaderInput vertexInput);
            void SetInputAssembly(VkPrimitiveTopology topology);
            void SetDepthStencilState(bool depthTestEnable);
            void SetViewport(Rectangle* rect);
            void SetScissor(Rectangle* rect);

            void SetCullMode(VkCullModeFlags cullMode) { this->cullMode = cullMode; }
            void SetFrontFace(VkFrontFace frontFace) { this->frontFace = frontFace; }
            void SetLineWidth(float lineWidth) { this->lineWidth = lineWidth; }

            operator const VkPipeline &() const { return pipeline; }

            const VkPipeline &GetPipeline() const { return pipeline; }
            const VkPipelineLayout &GetPipelineLayout() const { return pipelineLayout; }
            const VkPipelineBindPoint &GetPipelineBindPoint() const { return pipelineBindPoint; }

        protected:
            VkDevice device;

            VkPipeline pipeline = VK_NULL_HANDLE;
            VkPipelineLayout pipelineLayout = VK_NULL_HANDLE;
            VkCullModeFlags cullMode = VK_CULL_MODE_NONE;
            VkFrontFace frontFace = VK_FRONT_FACE_COUNTER_CLOCKWISE;
            float lineWidth = 1.0f;

            VkPipelineBindPoint pipelineBindPoint;
            VkPipelineVertexInputStateCreateInfo vertexInputState;
            VkPipelineViewportStateCreateInfo viewportAndScissorState;
            VkPipelineInputAssemblyStateCreateInfo inputAssemblyState;
            VkPipelineMultisampleStateCreateInfo multisampleState;
            VkPipelineDepthStencilStateCreateInfo depthStencilState;
            VertexShaderInput vertexInput;
            VkViewport viewport;
            VkRect2D scissor;

            std::vector<VkPipelineColorBlendAttachmentState> colorBlendAttachmentStates;
    };
}}