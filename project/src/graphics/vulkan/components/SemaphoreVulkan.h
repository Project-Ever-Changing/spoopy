#pragma once

#include <graphics/ContextLayer.h>
#include <graphics/GPUResource.h>
#include <spoopy.h>

/*
 * A component class for the Haxe frontend semaphore
 * to be able to use as a handle.
 */

namespace lime { namespace spoopy {
    class GraphicsVulkan;
    class LogicalDevice;

    class SemaphoreVulkan: public GPUResource<VkSemaphore> {
        public:
            explicit SemaphoreVulkan(const LogicalDevice &device);

            VkSemaphore &GetSemaphore() { return semaphore; }

            void Create();

            void Destroy() override;

        private:
            VkSemaphoreCreateInfo semaphoreInfo = {};
            VkSemaphore semaphore;
    };
}}