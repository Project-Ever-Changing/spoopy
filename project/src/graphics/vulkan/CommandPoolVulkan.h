#pragma once

#include <helpers/SpoopyHelpers.h>

#ifdef SPOOPY_VOLK
#include <volk.h>
#endif

namespace lime {
    class CommandPoolVulkan {
        public:
            explicit CommandPoolVulkan();
            ~CommandPoolVulkan();

            operator const VkCommandPool &() const { return commandPool; }

            const VkCommandPool &GetCommandPool() const { return commandPool; }

        private:
            VkCommandPool commandPool = VK_NULL_HANDLE;
    };
}