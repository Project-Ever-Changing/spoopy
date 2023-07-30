#pragma once

#include <spoopy.h>

namespace lime { namespace spoopy {
    class PhysicalDevice;

    struct Capabilities {
        static uint32_t FindMemoryType(const PhysicalDevice &physicalDevice, uint32_t typeFilter, const VkMemoryPropertyFlags &requiredProperties);
        static bool IsAvailableExtension(const char* extensionName);
    };
}}
