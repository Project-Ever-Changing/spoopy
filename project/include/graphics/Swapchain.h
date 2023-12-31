#pragma once

#include "ContextLayer.h"

#include <SDL.h>
#include <spoopy.h>

namespace lime { namespace spoopy {
    #ifdef LIME_VULKAN
    using SContext = ContextVulkan;
    #endif

    class RenderTask;

    class Swapchain {
        protected:
            int32 width = 0;
            int32 height = 0;
            uint8_t numBackBuffers = 0;
            uint32_t presentCounter = 0;
            SDL_PixelFormatEnum format = SDL_PIXELFORMAT_UNKNOWN;

            const SContext& context;

            Swapchain(const SContext& context)
            : context(context) {}

            virtual ~Swapchain() = default;

        public:
            inline int32 GetWidth() const { return width; }
            inline int32 GetHeight() const { return height; }
            inline SDL_PixelFormatEnum GetFormat() const { return format; }
            inline float GetAspectRatio() const { return static_cast<float>(width) / height; }

            virtual void Present() { presentCounter++; }

        public:
            // TODO: With DX12, we need a begin/end pair for each render target.
    };
}}