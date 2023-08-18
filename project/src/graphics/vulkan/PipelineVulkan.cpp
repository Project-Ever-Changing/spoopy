#include "shaders/Shader.h"

#include "shaders/PipelineShader.h"
#include "PipelineVulkan.h"
#include "GraphicsVulkan.h"

#include <utils/MemoryReader.h>

#include <algorithm>

namespace lime { namespace spoopy {
    PipelineVulkan::PipelineVulkan(VkDevice device, bool pushDescriptors): device(device), pushDescriptors(pushDescriptors) {
        viewportAndScissorState = {};
        viewportAndScissorState.sType = VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO;
    }

    PipelineVulkan::~PipelineVulkan() {
        vkDestroyPipeline(device, pipeline, nullptr);
        vkDestroyPipelineLayout(device, pipelineLayout, nullptr);
    }

    void PipelineVulkan::SetInputAssembly(const PrimTopologyType& topology) {
        inputAssemblyState = {};
        inputAssemblyState.sType = VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO;
        inputAssemblyState.primitiveRestartEnable = VK_FALSE;

        switch(topology) {
            case PrimTopologyType::PointList:
                inputAssemblyState.topology = VK_PRIMITIVE_TOPOLOGY_POINT_LIST;
                break;
            case PrimTopologyType::LineList:
                inputAssemblyState.topology = VK_PRIMITIVE_TOPOLOGY_LINE_LIST;
                break;
            case PrimTopologyType::TriangleList:
                inputAssemblyState.topology = VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST;
                break;
            case PrimTopologyType::PatchList:
                inputAssemblyState.topology = VK_PRIMITIVE_TOPOLOGY_PATCH_LIST;
                break;
        }
    }

    void PipelineVulkan::SetVertexInput(MemoryReader& stream) {
        vertexInputState = {};
        vertexInputState.sType = VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO;
        vertexInputState.pNext = nullptr;
        vertexInputState.flags = 0;

        VkVertexInputBindingDescription bindings[SPOOPY_VS_MAX_INPUT_ELEMENTS];
        VkVertexInputAttributeDescription attributes[SPOOPY_VS_MAX_INPUT_ELEMENTS];

        for(uint32_t i=0; i<SPOOPY_VS_MAX_INPUT_ELEMENTS; i++) {
            bindings[i].binding = i;
            bindings[i].stride = 0;
            bindings[i].inputRate = VK_VERTEX_INPUT_RATE_VERTEX;
        }

        std::byte inputLayoutSize;
        stream.ReadBytes(&inputLayoutSize, sizeof(std::byte));
        SP_ASSERT(inputLayoutSize <= SPOOPY_VS_MAX_INPUT_ELEMENTS);

        uint32_t attributesCount = std::to_integer<uint32_t>(inputLayoutSize);
        uint32_t bindingsCount = 0;
        uint32_t offset = 0;

        /*
         * Assume that the following structs represent the description of each vertex attribute.
         */
        struct VADP {
            std::byte type;
            std::byte index;
            std::byte format;
            std::byte inputSlot;
            uint32_t alignedByteOffset;
            std::byte inputSlotClass;
            uint32_t instanceDataStepRate;
        };

        VADP descriptions[attributesCount];

        /*
         * Reading the vertex descriptions from the stream.
         */
        for(uint32_t i=0; i<attributesCount; i++) {
            stream.ReadBytes(reinterpret_cast<std::byte*>(&descriptions[i]), sizeof(VADP));
            uint32_t bindingSlot = std::to_integer<uint32_t>(descriptions[i].inputSlot);

            if(descriptions[i].alignedByteOffset != SPOOPY_INPUT_LAYOUT_ELEMENT_ALIGN) {
                offset = descriptions[i].alignedByteOffset;
            }

            auto& vertexBindingDescription = bindings[bindingSlot];
            vertexBindingDescription.binding = bindingSlot;
            vertexBindingDescription.stride = std::max(vertexBindingDescription.stride, (uint32_t)(offset + 32));
            vertexBindingDescription.inputRate = descriptions[i].inputSlotClass == 0 ? VK_VERTEX_INPUT_RATE_VERTEX : VK_VERTEX_INPUT_RATE_INSTANCE;
            SP_ASSERT(descriptions[i].instanceDataStepRate == 0 || descriptions[i].instanceDataStepRate == 1);

            auto& vertexAttributeDescription = attributes[i];
            vertexAttributeDescription.location = i;
            vertexAttributeDescription.binding = bindingSlot;
            vertexAttributeDescription.format = getFormatVk((PixelFormat)descriptions[i].format);
            vertexAttributeDescription.offset = offset;

            bindingsCount = std::max(bindingsCount, bindingSlot + 1);
            offset += 32;
        }

        vertexInputState.vertexBindingDescriptionCount = bindingsCount;
        vertexInputState.pVertexBindingDescriptions = bindings;
        vertexInputState.vertexAttributeDescriptionCount = attributesCount;
        vertexInputState.pVertexAttributeDescriptions = attributes;
    }

    void PipelineVulkan::CreateGraphicsPipeline(std::unique_ptr<PipelineShader> pipeline, VkRenderPass renderPass,
        VkPipelineCache pipelineCache, bool wireframe) {
        VkPipelineRasterizationStateCreateInfo rasterizationState = {};
        rasterizationState.sType = VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO;
        rasterizationState.polygonMode = wireframe ? VK_POLYGON_MODE_LINE : VK_POLYGON_MODE_FILL;
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
        multisampleState.rasterizationSamples = GraphicsVulkan::GetCurrent()->MultisamplingEnabled
                                                ? GraphicsVulkan::GetCurrent()->GetPhysicalDevice()->GetMaxUsableSampleCount()
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
        pipelineInfo.pColorBlendState = &colorBlendState;
        pipelineInfo.pDynamicState = nullptr;
        pipelineInfo.pTessellationState = &tessellationState;
        pipelineInfo.layout = pipelineLayout;
        pipelineInfo.renderPass = renderPass;
        pipelineInfo.subpass = 0;
        pipelineInfo.basePipelineHandle = VK_NULL_HANDLE;
        pipelineInfo.basePipelineIndex = -1;
        checkVulkan(vkCreateGraphicsPipelines(device, pipelineCache, 1, &pipelineInfo, nullptr, &this->pipeline));
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

    void PipelineVulkan::SetScissor(Vector2T_u32 size) {
        VkRect2D scissor = {};

        scissor.offset = {
            0,
            0
        };
        scissor.extent = {
            size.x,
            size.y
        };

        viewportAndScissorState.scissorCount = 1;
        viewportAndScissorState.pScissors = &scissor;
    }

    void PipelineVulkan::SetTessellationState(uint32_t patchControlPoints) {
        tessellationState = {};
        tessellationState.sType = VK_STRUCTURE_TYPE_PIPELINE_TESSELLATION_STATE_CREATE_INFO;
        tessellationState.flags = 0;
        tessellationState.patchControlPoints = patchControlPoints;
    }

    void PipelineVulkan::SetPushConstantsRange(VkShaderStageFlags stageFlags, uint32_t size) {
        VkPushConstantRange range = {};
        range.stageFlags = stageFlags;
        range.offset = 0;
        range.size = size;
        pushConstantRanges.push_back(range);
    }

    void PipelineVulkan::SetColorBlendAttachment(VkBlendFactor srcColorBlendFactor, VkBlendFactor dstColorBlendFactor,
        VkBlendFactor srcAlphaBlendFactor, VkBlendFactor dstAlphaBlendFactor,
        VkBlendOp colorBlendOp, VkBlendOp alphaBlendOp) {
        colorBlendAttachmentStates.resize(colorBlendAttachments.size());

        for(size_t i=0; i<colorBlendAttachments.size(); ++i) {
            colorBlendAttachments[i].blendEnable = VK_FALSE;
            colorBlendAttachments[i].srcColorBlendFactor = srcColorBlendFactor;
            colorBlendAttachments[i].dstColorBlendFactor = dstColorBlendFactor;
            colorBlendAttachments[i].colorBlendOp = colorBlendOp;
            colorBlendAttachments[i].srcAlphaBlendFactor = srcAlphaBlendFactor;
            colorBlendAttachments[i].dstAlphaBlendFactor = dstAlphaBlendFactor;
            colorBlendAttachments[i].alphaBlendOp = alphaBlendOp;
            colorBlendAttachments[i].colorWriteMask = VK_COLOR_COMPONENT_R_BIT | VK_COLOR_COMPONENT_G_BIT | VK_COLOR_COMPONENT_B_BIT | VK_COLOR_COMPONENT_A_BIT;
            colorBlendAttachmentStates[i] = colorBlendAttachments[i];
        }

        colorBlendState = {};
        colorBlendState.sType = VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO;
        colorBlendState.logicOpEnable = VK_FALSE;
        colorBlendState.attachmentCount = static_cast<uint32_t>(colorBlendAttachmentStates.size());
        colorBlendState.pAttachments = colorBlendAttachmentStates.data();
    }

    void PipelineVulkan::SetColorBlendAttachment() {
        colorBlendAttachmentStates.resize(colorBlendAttachments.size());

        for(size_t i=0; i<colorBlendAttachments.size(); ++i) {
            colorBlendAttachments[i].blendEnable = VK_FALSE;
            colorBlendAttachmentStates[i] = colorBlendAttachments[i];
        }

        colorBlendState = {};
        colorBlendState.sType = VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO;
        colorBlendState.logicOpEnable = VK_FALSE;
        colorBlendState.attachmentCount = static_cast<uint32_t>(colorBlendAttachmentStates.size());
        colorBlendState.pAttachments = colorBlendAttachmentStates.data();
    }

    void PipelineVulkan::AddColorBlendAttachment() {
        VkPipelineColorBlendAttachmentState colorWriteMask = {};
        colorWriteMask.colorWriteMask = VK_COLOR_COMPONENT_R_BIT | VK_COLOR_COMPONENT_G_BIT | VK_COLOR_COMPONENT_B_BIT | VK_COLOR_COMPONENT_A_BIT;
        colorWriteMask.blendEnable = VK_FALSE;
        colorBlendAttachments.push_back(colorWriteMask);
    }
}}