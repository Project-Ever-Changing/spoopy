#pragma once

#include <graphics/GPUResource.h>
#include <spoopy.h>

/*
 * A component class for the Haxe frontend command pool
 * to be able to use as a handle.
 */

namespace lime { namespace spoopy {
    class GraphicsVulkan;
    class LogicalDevice;

    class CommandPoolVulkan: public GPUResource<VkCommandPool> {
        public:
            explicit CommandPoolVulkan(const LogicalDevice &device, uint32_t queueFamily);
            ~CommandPoolVulkan();

        private:
            VkCommandPool &commandPool;
    };
}}