#pragma once

#include "../descriptors/IDescriptor.h"
#include "../CommandBufferVulkan.h"
#include "../../../device/PhysicalDevice.h"
#include "../../../device/LogicalDevice.h"

#include <math/Vector2T.h>

#include <vector>
#include <cmath>

namespace lime { namespace spoopy {
    class Image: public IDescriptor {
        public:
            Image(LogicalDevice device, VkFilter filter, VkSamplerAddressMode addressMode, VkSampleCountFlagBits samples, VkImageLayout layout, VkImageUsageFlags usage,
            VkFormat format, uint32_t mipLevels, uint32_t arrayLayers, const VkExtent3D &extent);

            ~Image();

            Description GetWriteDescriptor(uint32_t binding, VkDescriptorType descriptorType, Rectangle* rect) const;

            static VkDescriptorSetLayoutBinding GetDescriptorSetLayout(uint32_t binding, VkDescriptorType descriptorType, VkShaderStageFlags stage, uint32_t count);
            static VkFormat FindSupportedFormat(PhysicalDevice physicalDevice, const std::vector<VkFormat> &candidates, VkImageTiling tiling, VkFormatFeatureFlags features);
            static uint32_t GetMipLevels(const VkExtent3D &extent);

            static bool HasDepth(VkFormat format);
            static bool HasStencil(VkFormat format);

            const VkExtent3D &GetExtent() const { return extent; }
            VkFormat GetFormat() const { return format; }
            VkSampleCountFlagBits GetSamples() const { return samples; }
            VkImageUsageFlags GetUsage() const { return usage; }
            uint32_t GetMipLevels() const { return mipLevels; }
            uint32_t GetArrayLevels() const { return arrayLayers; }
            VkFilter GetFilter() const { return filter; }
            VkSamplerAddressMode GetAddressMode() const { return addressMode; }
            VkImageLayout GetLayout() const { return layout; }
            const VkImage &GetImage() { return image; }
            const VkDeviceMemory &GetMemory() { return memory; }
            const VkSampler &GetSampler() const { return sampler; }
            const VkImageView &GetView() const { return view; }

        static void CreateImage(PhysicalDevice physicalDevice, LogicalDevice device, VkImage &image, VkDeviceMemory &memory, const VkExtent3D &extent, VkFormat format, VkSampleCountFlagBits samples,
            VkImageTiling tiling, VkImageUsageFlags usage, VkMemoryPropertyFlags properties, uint32_t mipLevels, uint32_t arrayLayers, VkImageType type);
        static void CreateImageSampler(PhysicalDevice physicalDevice, LogicalDevice device, VkSampler &sampler, VkFilter filter, VkSamplerAddressMode addressMode, bool anisotropic, uint32_t mipLevels);
        static void CreateImageView(LogicalDevice device, const VkImage &image, VkImageView &imageView, VkImageViewType type, VkFormat format, VkImageAspectFlags imageAspect,
            uint32_t mipLevels, uint32_t baseMipLevel, uint32_t layerCount, uint32_t baseArrayLayer);
        static void TransitionImageLayout(LogicalDevice device, const VkImage &image, VkFormat format, VkImageLayout srcImageLayout, VkImageLayout dstImageLayout,
            VkImageAspectFlags imageAspect, uint32_t mipLevels, uint32_t baseMipLevel, uint32_t layerCount, uint32_t baseArrayLayer);
        static void CreateMipmaps(PhysicalDevice physicalDevice, LogicalDevice device, const VkImage &image, const VkExtent3D &extent, VkFormat format, VkImageLayout dstImageLayout,
            uint32_t mipLevels, uint32_t baseArrayLayer, uint32_t layerCount);
        static void CopyBufferToImage(LogicalDevice device, const VkBuffer &buffer, const VkImage &image, const VkExtent3D &extent, uint32_t mipLevels, uint32_t baseArrayLayer, uint32_t layerCount);

        protected:
            LogicalDevice device;

            VkExtent3D extent;
            VkSampleCountFlagBits samples;
            VkImageUsageFlags usage;
            VkFormat format = VK_FORMAT_UNDEFINED;
            uint32_t mipLevels = 0;
            uint32_t arrayLayers;

            VkFilter filter;
            VkSamplerAddressMode addressMode;

            VkImageLayout layout;

            VkImage image = VK_NULL_HANDLE;
            VkDeviceMemory memory = VK_NULL_HANDLE;
            VkSampler sampler = VK_NULL_HANDLE;
            VkImageView view = VK_NULL_HANDLE;
    };
}}