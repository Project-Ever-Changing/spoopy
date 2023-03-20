#pragma once

const uint8_t SPOOPY_UNIFORM_FRAGMENT_BIT = 0x10;
const uint8_t SPOOPY_UNIFORM_VERTEX_BIT = 0x20;

#if defined(SPOOPY_VOLK) && defined(SPOOPY_VULKAN)
#include <volk.h>
#endif

#ifdef SPOOPY_VULKAN
    typedef VkGraphicsPipelineCreateInfo *SpoopyPipelineDescriptor;
    typedef VkPipeline SpoopyPipelineState;
    typedef VkFormat SpoopyPixelFormat;
#endif