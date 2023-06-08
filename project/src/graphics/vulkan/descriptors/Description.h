#pragma once

#include <spoopy.h>
#include <memory>

namespace lime { namespace spoopy {
    class Description {
        public:
            Description(const VkWriteDescriptorSet &writeDescriptorSet, const VkDescriptorImageInfo &imageInfo);
            Description(const VkWriteDescriptorSet &writeDescriptorSet, const VkDescriptorBufferInfo &bufferInfo);

            ~Description();

            const VkWriteDescriptorSet &GetWriteDescriptorSet() const { return writeDescriptorSet; }

        private:
            VkWriteDescriptorSet writeDescriptorSet;

            VkDescriptorImageInfo imageInfo;
            VkDescriptorBufferInfo bufferInfo;
    };
}}
