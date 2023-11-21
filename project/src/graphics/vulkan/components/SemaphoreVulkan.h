#pragma once

#include <graphics/ContextLayer.h>
#include <graphics/BufferWrapper.h>
#include <spoopy.h>

/*
 * A component class for the Haxe frontend semaphore
 * to be able to use as a handle.
 */

namespace lime { namespace spoopy {
    class GraphicsVulkan;
    class LogicalDevice;

    class SemaphoreVulkan: BufferWrapper<VkSemaphore> {
        public:
            explicit SemaphoreVulkan(const LogicalDevice &device);
            ~SemaphoreVulkan();
        private:
            VkSemaphore& semaphore;
    };
}}