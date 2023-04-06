#pragma once

/*
 * This header file contains all the types and macros that are used by the renderer.
 */

#include <assert.h>

#define SPOOPY_SAFE_DELETE_ARRAY(p) do {if(p) { delete[] (p); (p) = nullptr;}} while(0)

#if SPOOPY_DISABLE_ASSERT > 0
#define SPOOPY_ASSERT(cond)
#else
#define SPOOPY_ASSERT(cond) assert(cond)
#endif

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