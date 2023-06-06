#pragma once

#include <spoopy.h>

namespace lime { namespace spoopy {
    class CommandPoolVulkan {
        public:
            explicit CommandPoolVulkan();
            ~CommandPoolVulkan();

            operator const VkCommandPool &() const { return commandPool; }

            const VkCommandPool &GetCommandPool() const { return commandPool; }

        private:
            VkCommandPool commandPool = VK_NULL_HANDLE;
    };
}}