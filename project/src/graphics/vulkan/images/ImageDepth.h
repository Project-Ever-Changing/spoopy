#pragma once

#include "Image.h"

namespace lime { namespace spoopy {
    class ImageDepth: public Image {
        public:
            explicit ImageDepth(PhysicalDevice physicalDevice, LogicalDevice device, const Vector2T_u32 &size, VkSampleCountFlagBits samples = VK_SAMPLE_COUNT_1_BIT);
    };
}}
