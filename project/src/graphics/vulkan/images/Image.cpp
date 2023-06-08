#include "Image.h"

namespace lime { namespace spoopy {
    Image::Image(VkDevice device, VkFilter filter, VkSamplerAddressMode addressMode, VkSampleCountFlagBits samples, VkImageLayout layout, VkImageUsageFlags usage, VkFormat format, uint32_t mipLevels,
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

    VkFormat Image::FindSupportedFormat(VkPhysicalDevice physicalDevice, const std::vector<VkFormat> &candidates, VkImageTiling tiling, VkFormatFeatureFlags features) {
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
}}