#pragma once

#include "../../helpers/SpoopyHelpersVulkan.h"

#include <vector>

namespace lime { namespace spoopy {
    class Window;
    class LogicalDevice;
    class Surface;

    class SwapchainVulkan {
        public:
            SwapchainVulkan(const LogicalDevice& device, const Surface& surface);
        private:
            const LogicalDevice &logicalDevice;
            const Surface &surface;
    };
}}