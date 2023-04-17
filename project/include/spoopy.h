#pragma once

/*
 * This header file contains all the types and macros that are used by the renderer.
 */

#include <assert.h>

#define MAX_COLOR_ATTACHMENT 1

#define SPOOPY_SAFE_DELETE_ARRAY(p) do {if(p) { delete[] (p); (p) = nullptr;}} while(0)

#if SPOOPY_DISABLE_ASSERT > 0
#define SPOOPY_ASSERT(cond)
#else
#define SPOOPY_ASSERT(cond) assert(cond)
#endif

#define CLAMP(x, low, high) ({\
  __typeof__(x) __x = (x); \
  __typeof__(low) __low = (low);\
  __typeof__(high) __high = (high);\
  __x > __high ? __high : (__x < __low ? __low : __x);\
  })

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