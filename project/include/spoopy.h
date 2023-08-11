#pragma once

/*
 * This header file contains all the types and macros that are used by the renderer.
 */

#if defined(SPOOPY_VOLK) && defined(SPOOPY_VULKAN)
#include <volk.h>
#endif

#include <vk_mem_alloc.h>

#if __cplusplus == 201103L

#include <memory>
#include <utility>

namespace std {
    template<typename T, typename... Args> std::unique_ptr<T> make_unique(Args&&... args) {
        return std::unique_ptr<T>(new T(std::forward<Args>(args)...));
    }
}

#endif