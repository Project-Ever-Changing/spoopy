#pragma once

/*
 * This header file contains all the types and macros that are used by the renderer.
 */

#if defined(SPOOPY_VOLK) && defined(SPOOPY_VULKAN)
#include <volk.h>
#endif

#ifdef SPOOPY_VULKAN
    typedef VkGraphicsPipelineCreateInfo *SpoopyPipelineDescriptor;
    typedef VkPipeline SpoopyPipelineState;
    typedef VkFormat SpoopyPixelFormat;
#endif