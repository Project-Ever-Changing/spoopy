#include "Description.h"

namespace lime { namespace spoopy {
    Description::Description(const VkWriteDescriptorSet &writeDescriptorSet, const VkDescriptorImageInfo &imageInfo):
    writeDescriptorSet(writeDescriptorSet),
    imageInfo(imageInfo) {
        this->writeDescriptorSet.pImageInfo = &this->imageInfo;
    }

    Description::Description(const VkWriteDescriptorSet &writeDescriptorSet, const VkDescriptorBufferInfo &bufferInfo):
    writeDescriptorSet(writeDescriptorSet),
    bufferInfo(bufferInfo) {
        this->writeDescriptorSet.pBufferInfo = &this->bufferInfo;
    }
}}