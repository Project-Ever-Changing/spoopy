#pragma once

#include <spoopy.h>

namespace lime { namespace spoopy {
    class GraphicsVulkan;
    class LogicalDevice;

    class CommandPoolVulkan {
        public:
            explicit CommandPoolVulkan(const LogicalDevice &device, uint32_t queueFamily);
            ~CommandPoolVulkan();

            operator const VkCommandPool &() const { return commandPool; }

            const VkCommandPool &GetCommandPool() const { return commandPool; }

        private:
            VkCommandPool commandPool = VK_NULL_HANDLE;
    };
}}