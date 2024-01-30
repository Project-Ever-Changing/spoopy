#pragma once

#include "../../helpers/SpoopyHelpersVulkan.h"

#include <graphics/GPUResource.h>
#include <graphics/PixelFormat.h>
#include <spoopy_hash.h>

#include <vector>

#ifdef SPOOPY_SDL
#include <SDL.h>
#endif

/*
 * TODO: Allow users to clear the hash table
 */
namespace lime { namespace spoopy {
    class LogicalDevice;

    struct RenderPassValue {
        bool hasDepth = false;
        bool hasStencil = false;
        int numColorAttachments = 0;
        int MSAALevel = 1;

        bool writeDepth = false;
        bool readDepth = false;

        VkFormat colorFormat = VK_FORMAT_UNDEFINED;

        // TODO: Add depth buffer that isn't bound to a frontend wrapper class

        virtual bool operator==(const RenderPassValue& other) const {
            return hasDepth == other.hasDepth
           && hasStencil == other.hasStencil
           && numColorAttachments == other.numColorAttachments
           && MSAALevel == other.MSAALevel
           && colorFormat == other.colorFormat;
        }
    };

    struct RenderPassKey: public hashable<RenderPassValue> {
        VkRenderPass pass;
        const LogicalDevice &device;

        RenderPassKey(const LogicalDevice &device);
        ~RenderPassKey();

        std::size_t GetHash(const uint16_t &start) const override;
    };

    class RenderPassVulkan: public GPUResource<hashtable<RenderPassValue>> {
        public:
            explicit RenderPassVulkan(const LogicalDevice &device, const VkFormat &format, const int &msaaLevel);

            void Create();
            void Destroy() override;

        public:
            RenderPassKey createInfo;
            // static RenderPassVulkan* GetOrCreate(const RenderPassCreateInfo &createInfo);

        private:
            bool prevDepthLoaded = false;
    };
}}