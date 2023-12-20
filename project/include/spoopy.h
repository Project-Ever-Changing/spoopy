#pragma once

#if defined(__WIN32__)
#include <Windows.h>
#else
#include <unistd.h>
#endif

/*
 * This header file contains all the types and macros that are used by the renderer.
 */

typedef signed int int32;

#if defined(SPOOPY_VOLK) && defined(SPOOPY_VULKAN)
#include <volk.h>

#define SPOOPY_SAFE_DESTROY_VULKAN(resource, device, handle)  \
    if (resourceHandle != VK_NULL_HANDLE) {                   \
        vkDestroy##resource(device, resourceHandle, nullptr); \
        resourceHandle = VK_NULL_HANDLE;                      \
    }

#include <vk_mem_alloc.h>

#endif


#if __cplusplus == 201103L

#include <memory>
#include <utility>

namespace std { // Future C++ version intergration
    template<typename T, typename... Args> std::unique_ptr<T> make_unique(Args&&... args) {
        return std::unique_ptr<T>(new T(std::forward<Args>(args)...));
    }
}

#endif


namespace platform {
    inline void sleep(int32 milliseconds) {

        #if defined(__WIN32__) // "Borrowed" code

        static thread_local HANDLE timer = NULL;

        if (timer == NULL) {
            timer = CreateWaitableTimerEx(NULL, NULL, CREATE_WAITABLE_TIMER_HIGH_RESOLUTION, TIMER_ALL_ACCESS);
            if (timer == NULL) timer = CreateWaitableTimer(NULL, TRUE, NULL);
        }

        LARGE_INTEGER dueTime;
        dueTime.QuadPart = -int64_t(milliseconds) * 10000;

        SetWaitableTimerEx(timer, &dueTime, 0, NULL, NULL, NULL, 0);
        WaitForSingleObject(timer, INFINITE);

        #else

        usleep(milliseconds * 1000);

        #endif
    }
}

#define SPOOPY_VS_MAX_INPUT_ELEMENTS 16
#define SPOOPY_INPUT_LAYOUT_ELEMENT_ALIGN 0xffffffff