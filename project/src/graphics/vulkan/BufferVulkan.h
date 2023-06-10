#pragma once

#include "../../helpers/SpoopyHelpersVulkan.h"

namespace lime { namespace spoopy {
    class LogicalDevice;
    class PhysicalDevice;

    class BufferVulkan {
        public:
            BufferVulkan(PhysicalDevice physicalDevice, LogicalDevice device, VkDeviceSize size, VkBufferUsageFlags usage,
                VkMemoryPropertyFlags properties, const void* data = nullptr);
            virtual ~BufferVulkan();

            VkDeviceSize GetSize() const { return size; }
            const VkBuffer &GetBuffer() const { return buffer; }
            const VkDeviceMemory &GetBufferMemory() const { return bufferMemory; }

            void MapMemory(LogicalDevice device, void** data) const;
            void UnmapMemory(LogicalDevice device) const;

        protected:
            VkDeviceSize size;
            VkDevice device = VK_NULL_HANDLE;
            VkBuffer buffer = VK_NULL_HANDLE;
            VkDeviceMemory bufferMemory = VK_NULL_HANDLE;
    };
}}