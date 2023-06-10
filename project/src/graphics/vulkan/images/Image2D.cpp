#include "Image2D.h"

namespace lime { namespace spoopy {
    void Image2D::LoadEmpty(PhysicalDevice physicalDevice, LogicalDevice device, bool loadMipmap) {
        if(extent.width == 0 || extent.height == 0) {
            SPOOPY_LOG_WARN("Image2D::LoadEmpty() called with extent.width == 0 || extent.height == 0");
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