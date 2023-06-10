#include "../../device/LogicalDevice.h"
#include "../../device/PhysicalDevice.h"
#include "../../device/Capabilities.h"
#include "BufferVulkan.h"

#include <array>

namespace lime { namespace spoopy {
    BufferVulkan::BufferVulkan(PhysicalDevice physicalDevice, LogicalDevice device, VkDeviceSize size, VkBufferUsageFlags usage, VkMemoryPropertyFlags properties, const void *data):
        size(size) {
        auto graphicsFamily = device.GetGraphicsFamily();
        auto presentFamily = device.GetPresentFamily();
        auto computeFamily = device.GetComputeFamily();

        std::array<uint32_t, 3> queueFamilyIndices = {graphicsFamily, presentFamily, computeFamily};

        VkBufferCreateInfo bufferInfo = {};
        bufferInfo.sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
        bufferInfo.size = size;
        bufferInfo.usage = usage;
        bufferInfo.sharingMode = VK_SHARING_MODE_EXCLUSIVE;
        bufferInfo.queueFamilyIndexCount = static_cast<uint32_t>(queueFamilyIndices.size());
        bufferInfo.pQueueFamilyIndices = queueFamilyIndices.data();
        checkVulkan(vkCreateBuffer(device, &bufferInfo, nullptr, &buffer));

        VkMemoryRequirements memRequirements;
        vkGetBufferMemoryRequirements(device, buffer, &memRequirements);

        VkMemoryAllocateInfo allocInfo = {};
        allocInfo.sType = VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO;
        allocInfo.allocationSize = memRequirements.size;
        allocInfo.memoryTypeIndex = Capabilities::FindMemoryType(physicalDevice, memRequirements.memoryTypeBits, properties);
        checkVulkan(vkAllocateMemory(device, &allocInfo, nullptr, &bufferMemory));

        if(data) {
            void* mapped;
            checkVulkan(vkMapMemory(device, bufferMemory, 0, size, 0, &mapped));
            std::memcpy(mapped, data, size);

            if((properties & VK_MEMORY_PROPERTY_HOST_COHERENT_BIT) == 0) {
                VkMappedMemoryRange mappedRange = {};
                mappedRange.sType = VK_STRUCTURE_TYPE_MAPPED_MEMORY_RANGE;
                mappedRange.memory = bufferMemory;
                mappedRange.offset = 0;
                mappedRange.size = size;
                vkFlushMappedMemoryRanges(device, 1, &mappedRange);
            }

            vkUnmapMemory(device, bufferMemory);
        }

        checkVulkan(vkBindBufferMemory(device, buffer, bufferMemory, 0));
    }

    BufferVulkan::~BufferVulkan() {
        vkDestroyBuffer(device, buffer, nullptr);
        vkFreeMemory(device, bufferMemory, nullptr);
    }

    void BufferVulkan::MapMemory(LogicalDevice device, void **data) const {
        vkMapMemory(device, bufferMemory, 0, size, 0, data);
    }

    void BufferVulkan::UnmapMemory(LogicalDevice device) const {
        vkUnmapMemory(device, bufferMemory);
    }
}}