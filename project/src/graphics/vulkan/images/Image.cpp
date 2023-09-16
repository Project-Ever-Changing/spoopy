#include "../../../device/Capabilities.h"
#include "Image.h"

#include <assert.h>

namespace lime { namespace spoopy {
    Image::Image(const LogicalDevice &device, VkFilter filter, VkSamplerAddressMode addressMode, VkSampleCountFlagBits samples, VkImageLayout layout, VkImageUsageFlags usage, VkFormat format, uint32_t mipLevels,
        uint32_t arrayLayers, const VkExtent3D &extent):
        device(device),
        filter(filter),
        addressMode(addressMode),
        samples(samples),
        layout(layout),
        usage(usage),
        format(format),
        mipLevels(mipLevels),
        arrayLayers(arrayLayers),
        extent(extent) {
    }

    Image::~Image() {
        vkDestroyImageView(device, view, nullptr);
        vkDestroySampler(device, sampler, nullptr);
        vkDestroyImage(device, image, nullptr);
        vkFreeMemory(device, memory, nullptr);
    }

    Description Image::GetWriteDescriptor(uint32_t binding, VkDescriptorType descriptorType, Rectangle* rect) const {
        VkDescriptorImageInfo imageInfo = {};
        imageInfo.sampler = sampler;
        imageInfo.imageView = view;
        imageInfo.imageLayout = layout;

        VkWriteDescriptorSet descriptorWrite = {};
        descriptorWrite.sType = VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET;
        descriptorWrite.dstSet = VK_NULL_HANDLE;
        descriptorWrite.dstBinding = binding;
        descriptorWrite.dstArrayElement = 0;
        descriptorWrite.descriptorCount = 1;
        descriptorWrite.descriptorType = descriptorType;
        return {descriptorWrite, imageInfo};
    }

    VkDescriptorSetLayoutBinding Image::GetDescriptorSetLayout(uint32_t binding, VkDescriptorType descriptorType, VkShaderStageFlags stage, uint32_t count) {
        VkDescriptorSetLayoutBinding descriptorSetLayoutBinding = {};
        descriptorSetLayoutBinding.binding = binding;
        descriptorSetLayoutBinding.descriptorType = descriptorType;
        descriptorSetLayoutBinding.descriptorCount = 1;
        descriptorSetLayoutBinding.stageFlags = stage;
        descriptorSetLayoutBinding.pImmutableSamplers = nullptr;

        return descriptorSetLayoutBinding;
    }

    VkFormat Image::FindSupportedFormat(const PhysicalDevice &physicalDevice, const std::vector<VkFormat> &candidates, VkImageTiling tiling, VkFormatFeatureFlags features) {
        for(VkFormat format: candidates) {
            VkFormatProperties properties;
            vkGetPhysicalDeviceFormatProperties(physicalDevice, format, &properties);

            if (tiling == VK_IMAGE_TILING_LINEAR && (properties.linearTilingFeatures & features) == features) {
                return format;
            } else if (tiling == VK_IMAGE_TILING_OPTIMAL && (properties.optimalTilingFeatures & features) == features) {
                return format;
            }
        }

        throw std::runtime_error("Failed to find supported format!");
    }

    uint32_t Image::GetMipLevels(const VkExtent3D &extent) {
        return static_cast<uint32_t>(std::floor(std::log2(std::max(extent.width, std::max(extent.height, extent.depth)))) + 1);
    }

    bool Image::HasDepth(VkFormat format) {
        static const std::vector<VkFormat> DEPTH_FORMATS = {
                VK_FORMAT_D16_UNORM, VK_FORMAT_X8_D24_UNORM_PACK32, VK_FORMAT_D32_SFLOAT, VK_FORMAT_D16_UNORM_S8_UINT,
                VK_FORMAT_D24_UNORM_S8_UINT, VK_FORMAT_D32_SFLOAT_S8_UINT
        };

        return std::find(DEPTH_FORMATS.begin(), DEPTH_FORMATS.end(), format) != std::end(DEPTH_FORMATS);
    }

    bool Image::HasStencil(VkFormat format) {
        static const std::vector<VkFormat> STENCIL_FORMATS = {VK_FORMAT_S8_UINT, VK_FORMAT_D16_UNORM_S8_UINT, VK_FORMAT_D24_UNORM_S8_UINT, VK_FORMAT_D32_SFLOAT_S8_UINT};
        return std::find(STENCIL_FORMATS.begin(), STENCIL_FORMATS.end(), format) != std::end(STENCIL_FORMATS);
    }

    void Image::CreateImage(const PhysicalDevice &physicalDevice, const LogicalDevice &device, VkImage &image, VkDeviceMemory &memory, const VkExtent3D &extent, VkFormat format, VkSampleCountFlagBits samples,
                            VkImageTiling tiling, VkImageUsageFlags usage, VkMemoryPropertyFlags properties, uint32_t mipLevels, uint32_t arrayLayers, VkImageType type) {
        VkImageCreateInfo imageInfo = {};
        imageInfo.sType = VK_STRUCTURE_TYPE_IMAGE_CREATE_INFO;
        imageInfo.imageType = type;
        imageInfo.format = format;
        imageInfo.extent = extent;
        imageInfo.mipLevels = mipLevels;
        imageInfo.arrayLayers = arrayLayers;
        imageInfo.samples = samples;
        imageInfo.tiling = tiling;
        imageInfo.usage = usage;
        imageInfo.flags = arrayLayers == 6 ? VK_IMAGE_CREATE_CUBE_COMPATIBLE_BIT : 0;
        imageInfo.sharingMode = VK_SHARING_MODE_EXCLUSIVE;
        imageInfo.initialLayout = VK_IMAGE_LAYOUT_UNDEFINED;
        checkVulkan(vkCreateImage(device, &imageInfo, nullptr, &image));

        VkMemoryRequirements memoryRequirements;
        vkGetImageMemoryRequirements(device, image, &memoryRequirements);

        VkMemoryAllocateInfo memoryAllocateInfo = {};
        memoryAllocateInfo.sType = VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO;
        memoryAllocateInfo.allocationSize = memoryRequirements.size;
        memoryAllocateInfo.memoryTypeIndex = Capabilities::FindMemoryType(physicalDevice, memoryRequirements.memoryTypeBits, properties);
        checkVulkan(vkAllocateMemory(device, &memoryAllocateInfo, nullptr, &memory));
        checkVulkan(vkBindImageMemory(device, image, memory, 0));
    }

    void Image::CreateImageSampler(const PhysicalDevice &physicalDevice, const LogicalDevice &device, VkSampler &sampler, VkFilter filter, VkSamplerAddressMode addressMode, bool anisotropic, uint32_t mipLevels) {
        VkSamplerCreateInfo samplerInfo = {};
        samplerInfo.sType = VK_STRUCTURE_TYPE_SAMPLER_CREATE_INFO;
        samplerInfo.magFilter = filter;
        samplerInfo.minFilter = filter;
        samplerInfo.addressModeU = addressMode;
        samplerInfo.addressModeV = addressMode;
        samplerInfo.addressModeW = addressMode;
        samplerInfo.anisotropyEnable = VK_FALSE;
        samplerInfo.maxAnisotropy = 1;
        samplerInfo.borderColor = VK_BORDER_COLOR_INT_OPAQUE_BLACK;
        samplerInfo.unnormalizedCoordinates = VK_FALSE;
        samplerInfo.compareEnable = VK_FALSE;
        samplerInfo.compareOp = VK_COMPARE_OP_ALWAYS;
        samplerInfo.mipmapMode = VK_SAMPLER_MIPMAP_MODE_LINEAR;
        samplerInfo.mipLodBias = 0.0f;
        samplerInfo.minLod = 0.0f;
        samplerInfo.maxLod = static_cast<float>(mipLevels);

        if(device.GetEnabledFeatures().samplerAnisotropy && anisotropic && physicalDevice.GetProperties().limits.maxSamplerAnisotropy > 1.0f) {
            samplerInfo.maxAnisotropy = physicalDevice.GetProperties().limits.maxSamplerAnisotropy;
            samplerInfo.anisotropyEnable = VK_TRUE;
        }

        checkVulkan(vkCreateSampler(device, &samplerInfo, nullptr, &sampler));
    }

    void Image::CreateImageView(const LogicalDevice &device, const VkImage &image, VkImageView &imageView, VkImageViewType type, VkFormat format, VkImageAspectFlags imageAspect,
                                uint32_t mipLevels, uint32_t baseMipLevel, uint32_t layerCount, uint32_t baseArrayLayer) {
        VkImageViewCreateInfo imageViewInfo = {};
        imageViewInfo.sType = VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
        imageViewInfo.image = image;
        imageViewInfo.viewType = type;
        imageViewInfo.format = format;
        imageViewInfo.components = {VK_COMPONENT_SWIZZLE_R, VK_COMPONENT_SWIZZLE_G, VK_COMPONENT_SWIZZLE_B, VK_COMPONENT_SWIZZLE_A};
        imageViewInfo.subresourceRange.aspectMask = imageAspect;
        imageViewInfo.subresourceRange.baseMipLevel = baseMipLevel;
        imageViewInfo.subresourceRange.levelCount = mipLevels;
        imageViewInfo.subresourceRange.baseArrayLayer = baseArrayLayer;
        imageViewInfo.subresourceRange.layerCount = layerCount;
        checkVulkan(vkCreateImageView(device, &imageViewInfo, nullptr, &imageView));
    }
}}