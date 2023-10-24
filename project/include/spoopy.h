#pragma once

/*
 * This header file contains all the types and macros that are used by the renderer.
 */

#if defined(SPOOPY_VOLK) && defined(SPOOPY_VULKAN)
#include <volk.h>

#define SPOOPY_SAFE_DESTROY_VULKAN(resource, device, handle)  \
    if (resourceHandle != VK_NULL_HANDLE) {                   \
        vkDestroy##resource(device, resourceHandle, nullptr); \
        resourceHandle = VK_NULL_HANDLE;                      \
    }

#endif

#include <vk_mem_alloc.h>

#if __cplusplus == 201103L

#include <memory>
#include <utility>

namespace std { // Future C++ version intergration
    template<typename T, typename... Args> std::unique_ptr<T> make_unique(Args&&... args) {
        return std::unique_ptr<T>(new T(std::forward<Args>(args)...));
    }
}

#endif

#define SPOOPY_VS_MAX_INPUT_ELEMENTS 16
#define SPOOPY_INPUT_LAYOUT_ELEMENT_ALIGN 0xffffffff