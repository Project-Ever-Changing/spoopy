#include "../BufferVulkan.h"
#include "Image2D.h"

namespace lime { namespace spoopy {
    Image2D::Image2D(PhysicalDevice physicalDevice, LogicalDevice device, const Vector2T_u32 &extent, VkFormat format, VkImageLayout layout, VkImageUsageFlags usage, VkFilter filter,
        VkSamplerAddressMode addressMode, VkSampleCountFlagBits samples, bool anisotropic, bool mipmap):
        Image(device, filter, addressMode, samples, layout,
            usage | VK_IMAGE_USAGE_TRANSFER_SRC_BIT | VK_IMAGE_USAGE_TRANSFER_DST_BIT | VK_IMAGE_USAGE_SAMPLED_BIT,
            format, 1, 1, {extent.x, extent.y, 1}),
        anisotropic(anisotropic),
        mipmap(mipmap),
        components(4) {
        LoadEmpty(physicalDevice, true);
    }

    void Image2D::SetPixels(PhysicalDevice physicalDevice, const uint8_t *pixels, uint32_t layerCount, uint32_t baseArrayLayer) {
        BufferVulkan buffer(physicalDevice, device, extent.width * extent.height * components * arrayLayers,
            VK_BUFFER_USAGE_TRANSFER_SRC_BIT, VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT | VK_MEMORY_PROPERTY_HOST_COHERENT_BIT);

        void* data;
        buffer.MapMemory(device, &data);
        memcpy(data, pixels, buffer.GetSize());
        buffer.UnmapMemory(device);

        CopyBufferToImage(device, buffer.GetBuffer(), image, extent, arrayLayers, layerCount, baseArrayLayer);
    }

    void Image2D::LoadEmpty(PhysicalDevice physicalDevice, bool loadMipmap) {
        if(extent.width == 0 || extent.height == 0) {
            // SPOOPY_LOG_WARN("Image2D::LoadEmpty() called with extent.width == 0 || extent.height == 0");
            return;
        }

        mipLevels = mipmap ? GetMipLevels(extent) : 1;

        CreateImage(physicalDevice, device, image, memory, extent, format, samples, VK_IMAGE_TILING_OPTIMAL, usage, VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT,
            mipLevels, arrayLayers, VK_IMAGE_TYPE_2D);
        CreateImageSampler(physicalDevice, device, sampler, filter, addressMode, anisotropic, mipLevels);
        CreateImageView(device, image, view, VK_IMAGE_VIEW_TYPE_2D, format, VK_IMAGE_ASPECT_COLOR_BIT, mipLevels, 0, arrayLayers, 0);

        if(!loadMipmap) {
            return;
        }

        if(mipmap) {
            CreateMipmaps(physicalDevice, device, image, extent, format, layout, mipLevels, 0, arrayLayers);
        }else {
            TransitionImageLayout(device, image, format, VK_IMAGE_LAYOUT_UNDEFINED, layout, VK_IMAGE_ASPECT_COLOR_BIT, mipLevels, 0, arrayLayers, 0);
        }
    }
}}