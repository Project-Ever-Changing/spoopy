#pragma once

#include "Image.h"

#include <typeindex>

//TODO: Implement more constructors dedicated to front-end implementations.

namespace lime { namespace spoopy {
    class Image2D: public Image {
        public:
            explicit Image2D(PhysicalDevice physicalDevice, LogicalDevice device, const Vector2T_u32 &extent, VkFormat format = VK_FORMAT_R8G8B8A8_UNORM,
                 VkImageLayout layout = VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL, VkImageUsageFlags usage = VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT | VK_IMAGE_USAGE_STORAGE_BIT,
                 VkFilter filter = VK_FILTER_LINEAR, VkSamplerAddressMode addressMode = VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_EDGE,
                 VkSampleCountFlagBits samples = VK_SAMPLE_COUNT_1_BIT, bool anisotropic = false, bool mipmap = false);

            void SetPixels(const uint8_t *pixels, uint32_t layerCount, uint32_t baseArrayLayer);

            std::type_index GetTypeIndex() const { return typeid(Image2D); }

            bool IsAnisotropic() const { return anisotropic; }
            bool IsMipmap() const { return mipmap; }
            uint32_t GetComponents() const { return components; }

        private:
            // void Load(parameters);
            void LoadEmpty(PhysicalDevice physicalDevice, LogicalDevice device, bool loadMipmap = true);
            void LoadMipmap(PhysicalDevice physicalDevice, LogicalDevice device);

            bool anisotropic;
            bool mipmap;

            uint32_t components = 0;
    };
}}