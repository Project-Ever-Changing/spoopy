#pragma once

#include "../../helpers/SpoopyHelpersVulkan.h"
#include "shaders/VertexShaderInput.h"

#include <math/Rectangle.h>
#include <math/Vector2T.h>

/*
 * A general pipeline for both graphics and compute pipelines.
 */

namespace lime { namespace spoopy {
    class Shader;
    class PipelineShader;

    class PipelineVulkan {
        public:
            PipelineVulkan(VkDevice device, bool pushDescriptors = false);
            ~PipelineVulkan();

            void CreateGraphicsPipeline(std::unique_ptr<PipelineShader> pipeline, VkRenderPass renderPass,
                VkPipelineCache pipelineCache);
            void CreatePipelineLayout(std::vector<VkDescriptorSetLayoutBinding> bindings);

            void SetVertexInput(VertexShaderInput vertexInput);
            void SetInputAssembly(VkPrimitiveTopology topology);
            void SetDepthStencilState(bool depthTestEnable);
            void SetViewport(Rectangle* rect);
            void SetScissor(Vector2T_u32 size);
            void SetTessellationState(uint32_t patchControlPoints);
            void SetColorBlendAttachment(VkBlendFactor srcColorBlendFactor, VkBlendFactor dstColorBlendFactor,
                VkBlendFactor srcAlphaBlendFactor, VkBlendFactor dstAlphaBlendFactor,
                VkBlendOp colorBlendOp, VkBlendOp alphaBlendOp);
            void SetPushConstantsRange(VkShaderStageFlags stageFlags, uint32_t size);
            void SetColorBlendAttachment();

            void SetCullMode(VkCullModeFlags cullMode) { this->cullMode = cullMode; }
            void SetFrontFace(VkFrontFace frontFace) { this->frontFace = frontFace; }
            void SetLineWidth(float lineWidth) { this->lineWidth = lineWidth; }

            void AddColorBlendAttachment();

            operator const VkPipeline &() const { return pipeline; }

            const VkPipeline &GetPipeline() const { return pipeline; }
            const VkPipelineLayout &GetPipelineLayout() const { return pipelineLayout; }
            const VkPipelineBindPoint &GetPipelineBindPoint() const { return pipelineBindPoint; }

            std::vector<VkPipelineColorBlendAttachmentState> colorBlendAttachments;

        protected:
            VkDevice device;
            bool pushDescriptors;

            VkPipeline pipeline = VK_NULL_HANDLE;
            VkPipelineLayout pipelineLayout = VK_NULL_HANDLE;
            VkCullModeFlags cullMode = VK_CULL_MODE_NONE;
            VkFrontFace frontFace = VK_FRONT_FACE_COUNTER_CLOCKWISE;
            VkDescriptorSetLayout descriptorSetLayout = VK_NULL_HANDLE;
            float lineWidth = 1.0f;

            VkPipelineBindPoint pipelineBindPoint;
            VkPipelineVertexInputStateCreateInfo vertexInputState;
            VkPipelineViewportStateCreateInfo viewportAndScissorState;
            VkPipelineInputAssemblyStateCreateInfo inputAssemblyState;
            VkPipelineMultisampleStateCreateInfo multisampleState;
            VkPipelineDepthStencilStateCreateInfo depthStencilState;
            VkPipelineColorBlendStateCreateInfo colorBlendState;
            VkPipelineTessellationStateCreateInfo tessellationState;
            VertexShaderInput vertexInput;
            VkViewport viewport;
            VkRect2D scissor;

            std::vector<VkPipelineColorBlendAttachmentState> colorBlendAttachmentStates;
            std::vector<VkPushConstantRange> pushConstantRanges;
    };
}}