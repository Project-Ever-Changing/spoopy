#pragma once

#if defined(SPOOPY_VOLK) && defined(SPOOPY_VULKAN)
#include <volk.h>
#endif

#ifdef SPOOPY_VULKAN
    typedef VkGraphicsPipelineCreateInfo *SpoopyPipelineDescriptor;
    typedef VkPipeline SpoopyPipelineState;
    typedef VkFormat SpoopyPixelFormat;
#endif