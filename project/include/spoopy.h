#pragma once

/*
 * This header file contains all the types and macros that are used by the renderer.
 */

#if defined(SPOOPY_VOLK) && defined(SPOOPY_VULKAN)
#include <volk.h>
#endif

#if __cplusplus == 201103L

#include <memory>
#include <utility>

namespace std {
    template<typename T, typename... Args> std::unique_ptr<T> make_unique(Args&&... args) {
        return std::unique_ptr<T>(new T(std::forward<Args>(args)...));
    }
}

#endif