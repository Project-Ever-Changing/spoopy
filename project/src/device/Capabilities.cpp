#include "Capabilities.h"
#include "PhysicalDevice.h"

#include <memory>

namespace lime { namespace spoopy {
    uint32_t Capabilities::FindMemoryType(PhysicalDevice physicalDevice, uint32_t typeFilter, const VkMemoryPropertyFlags &requiredProperties) {
        auto memoryProperties = physicalDevice.GetMemoryProperties();

        for(uint32_t i = 0; i < memoryProperties.memoryTypeCount; i++) {
            if(typeFilter & (1 << i) && (memoryProperties.memoryTypes[i].propertyFlags & requiredProperties) == requiredProperties) {
                return i;
            }
        }

        throw std::runtime_error("Failed to find suitable memory type!");
    }
}}