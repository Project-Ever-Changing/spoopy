#pragma once

#include "../../device/Instance.h"
#include "../../device/LogicalDevice.h"
#include "../../device/PhysicalDevice.h"
#include "../../../include/graphics/ContextLayer.h"
#include "SwapchainVulkan.h"

#include <graphics/Viewport.h>
#include <math/Vector2T.h>

#include <sdl_definitions_config.h>
#include <vector>

namespace lime { namespace spoopy {
    class RenderPassVulkan;

    class GraphicsVulkan {
        public:
            friend class GraphicsHandler;

            GraphicsVulkan(SDL_Window* m_window);
            ~GraphicsVulkan();

            void Reset(const RenderPassVulkan &renderPass);
            void AcquireNextImage(const Context &context);
            void ResetPresent(const Context &context, const RenderPassVulkan &renderPass);
            void Record(const Context &context, const RenderPassVulkan &renderPass);
            void ChangeSize(const Context &context, const Viewport &viewport);

            static GraphicsVulkan *GetCurrent() { return Main.get(); }
            static bool MultisamplingEnabled;

            const PhysicalDevice *GetPhysicalDevice() const { return physicalDevice.get(); }
            const LogicalDevice *GetLogicalDevice() const { return logicalDevice.get(); }
            const VkPipelineCache &GetPipelineCache() const { return pipelineCache; }

            std::unique_ptr<Instance> instance;
            std::unique_ptr<PhysicalDevice> physicalDevice;
            std::unique_ptr<LogicalDevice> logicalDevice;

        private:
            static std::unique_ptr<GraphicsVulkan> Main;

            std::vector<std::shared_ptr<ContextVulkan>> contexts;

            VkExtent2D displayExtent;
            VkPipelineCache pipelineCache;

            bool startRender = false;
    };
}}