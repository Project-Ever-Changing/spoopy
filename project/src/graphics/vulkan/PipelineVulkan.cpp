#pragma once

#include "shaders/Shader.h"
#include "shaders/PipelineShader.h"
#include "PipelineVulkan.h"

namespace lime { namespace spoopy {
    PipelineVulkan::PipelineVulkan(int device): device(device) {
        viewportAndScissorState = {};
        viewportAndScissorState.sType = VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO;
    }

    PipelineVulkan::~PipelineVulkan() {
        vkDestroyPipeline(device, pipeline, nullptr);
        vkDestroyPipelineLayout(device, pipelineLayout, nullptr);
    }

    void PipelineVulkan::CreateGraphicsPipeline(std::unique_ptr<PipelineShader> pipeline, VkRenderPass renderPass) {
        VkPipelineRasterizationStateCreateInfo rasterizationState = {};
        rasterizationState.sType = VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO;
        rasterizationState.polygonMode = VK_POLYGON_MODE_FILL;
        rasterizationState.cullMode = cullMode;
        rasterizationState.frontFace = frontFace;
        rasterizationState.depthClampEnable = VK_FALSE;
        rasterizationState.rasterizerDiscardEnable = VK_FALSE;
        rasterizationState.depthBiasEnable = VK_FALSE;
        rasterizationState.lineWidth = lineWidth;
        rasterizationState.depthBiasConstantFactor = 0.0f;
        rasterizationState.depthBiasClamp = 0.0f;
        rasterizationState.depthBiasSlopeFactor = 0.0f;

        VkPipelineMultisampleStateCreateInfo multisampleState = {};
        multisampleState.sType = VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO;
        multisampleState.sampleShadingEnable = VK_FALSE;
        multisampleState.rasterizationSamples = GraphicsModule::GetCurrent()->MultisamplingEnabled
                                                ? GraphicsModule::GetCurrent()->GetPhysicalDevice()->GetMaxUsableSampleCount()
                                                : VK_SAMPLE_COUNT_1_BIT;
        multisampleState.pSampleMask = nullptr;
        multisampleState.minSampleShading = 1.0f;
        multisampleState.alphaToCoverageEnable = VK_FALSE;
        multisampleState.alphaToOneEnable = VK_FALSE;

        VkGraphicsPipelineCreateInfo pipelineInfo = {};
        pipelineInfo.sType = VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO;
        pipelineInfo.pStages = pipeline->GetStageInfos().data();
        pipelineInfo.stageCount = pipeline->GetStageInfos().size();
        pipelineInfo.pVertexInputState = &vertexInputState;
        pipelineInfo.pInputAssemblyState = &inputAssemblyState;
        pipelineInfo.pViewportState = &viewportAndScissorState;
        pipelineInfo.pRasterizationState = &rasterizationState;
        pipelineInfo.pMultisampleState = &multisampleState;
        pipelineInfo.pDepthStencilState = &depthStencilState;
    }

    void PipelineVulkan::SetVertexInput(VertexShaderInput vertexInput) {
        vertexInputState = {};
        vertexInputState.sType = VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO;
        vertexInputState.pNext = nullptr;
        vertexInputState.pVertexBindingDescriptions = vertexInput.GetBindingDescriptions().data();
        vertexInputState.vertexBindingDescriptionCount = vertexInput.GetBindingDescriptions().size();
        vertexInputState.pVertexAttributeDescriptions = vertexInput.GetAttributeDescriptions().data();
        vertexInputState.vertexAttributeDescriptionCount = vertexInput.GetAttributeDescriptions().size();
    }

    void PipelineVulkan::SetInputAssembly(VkPrimitiveTopology topology) {
        inputAssemblyState = {};
        inputAssemblyState.sType = VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO;
        inputAssemblyState.topology = topology;
        inputAssemblyState.primitiveRestartEnable = VK_FALSE;
    }

    void PipelineVulkan::SetDepthStencilState(bool depthTestEnable) {
        depthStencilState = {};
        depthStencilState.sType = VK_STRUCTURE_TYPE_PIPELINE_DEPTH_STENCIL_STATE_CREATE_INFO;
        depthStencilState.depthTestEnable = depthTestEnable ? VK_TRUE : VK_FALSE;
        depthStencilState.depthWriteEnable = VK_TRUE;
        depthStencilState.depthCompareOp = VK_COMPARE_OP_LESS;
        depthStencilState.depthBoundsTestEnable = VK_FALSE;
        depthStencilState.stencilTestEnable = VK_FALSE;
        depthStencilState.back.failOp = VK_STENCIL_OP_KEEP;
        depthStencilState.back.passOp = VK_STENCIL_OP_KEEP;
        depthStencilState.back.compareOp = VK_COMPARE_OP_ALWAYS;
        depthStencilState.front = depthStencilState.back;
    }

    void PipelineVulkan::SetViewport(Rectangle* rect) {
        VkViewport viewport = {};
        viewport.x = rect->x;
        viewport.y = rect->y;
        viewport.width = rect->width;
        viewport.height = rect->height;
        viewport.minDepth = 0.0f;
        viewport.maxDepth = 1.0f;

        viewportAndScissorState.viewportCount = 1;
        viewportAndScissorState.pViewports = &viewport;
    }

    void PipelineVulkan::SetScissor(Rectangle* rect) {
        VkRect2D scissor = {};

        scissor.offset = {
            static_cast<uint32_t>(rect->x),
            static_cast<uint32_t>(rect->y)
        };
        scissor.extent = {
            static_cast<uint32_t>(rect->width),
            static_cast<uint32_t>(rect->height)
        };

        viewportAndScissorState.scissorCount = 1;
        viewportAndScissorState.pScissors = &scissor;
    }
}}