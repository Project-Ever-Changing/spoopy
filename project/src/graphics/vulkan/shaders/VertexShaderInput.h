#pragma once

#include <spoopy.h>

namespace lime { namespace spoopy {
    class VertexShaderInput {
        public:
            VertexShaderInput(std::vector<VkVertexInputBindingDescription> bindingDescriptions = {}, std::vector<VkVertexInputAttributeDescription> attributeDescriptions = {}):
                bindingDescriptions(bindingDescriptions),
                attributeDescriptions(attributeDescriptions) {}

            const std::vector<VkVertexInputBindingDescription> &GetBindingDescriptions() const { return bindingDescriptions; }
            const std::vector<VkVertexInputAttributeDescription> &GetAttributeDescriptions() const { return attributeDescriptions; }

            bool operator<(const VertexInput &rhs) const {
                return bindingDescriptions.front().binding < rhs.bindingDescriptions.front().binding;
            }

        private:
            uint32_t binding = 0;

            std::vector<VkVertexInputBindingDescription> bindingDescriptions;
            std::vector<VkVertexInputAttributeDescription> attributeDescriptions;
    };
}}