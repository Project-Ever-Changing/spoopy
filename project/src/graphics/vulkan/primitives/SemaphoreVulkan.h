#pragma once

#include <graphics/ContextLayer.h>
#include <spoopy.h>

/*
 * A primitive class for the Haxe frontend semaphore
 * to be able to use as a handle.
 */

namespace lime { namespace spoopy {
    class GraphicsVulkan;
    class LogicalDevice;

    class SemaphoreVulkan {
        public:
            explicit SemaphoreVulkan(const LogicalDevice &device);

            operator const VkSemaphore &() const { return semaphore; }
            const VkSemaphore &GetSemaphore() const { return semaphore; }

            void Destroy();

        private:
            VkSemaphore semaphore;

            const LogicalDevice& device;
    };
}}