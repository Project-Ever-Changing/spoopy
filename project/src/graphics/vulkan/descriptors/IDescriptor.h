#pragma once

#include <math/Rectangle.h>

#include "Description.h"

namespace lime { namespace spoopy {
    class IDescriptor {
        public:
            IDescriptor() = default;
            virtual ~IDescriptor() = default;

            virtual Description GetWriteDescriptor(uint32_t binding, VkDescriptorType descriptorType, Rectangle* rect) const = 0;
    };
}}