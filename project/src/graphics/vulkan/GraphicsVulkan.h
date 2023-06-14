#pragma once

#include "../../device/Instance.h"
#include "../../device/LogicalDevice.h"
#include "../../device/PhysicalDevice.h"
#include "Stage.h"
#include "ContextVulkan.h"

#include <sdl_definitions_config.h>
#include <vector>

namespace lime { namespace spoopy {
    class GraphicsVulkan {
        public:
            friend class GraphicsHandler;

            GraphicsVulkan(SDL_Window* m_window);
            ~GraphicsVulkan();

            void Update();

            static GraphicsVulkan *GetCurrent() { return Main; }
            static bool MultisamplingEnabled;

            const PhysicalDevice *GetPhysicalDevice() const { return physicalDevice.get(); }
            const LogicalDevice *GetLogicalDevice() const { return logicalDevice.get(); }
            const VkPipelineCache &GetPipelineCache() const { return pipelineCache; }

        private:
            void Reset();
            void RecreateSwapchains();

            static GraphicsVulkan* Main;

            std::unique_ptr<Instance> instance;
            std::unique_ptr<PhysicalDevice> physicalDevice;
            std::unique_ptr<LogicalDevice> logicalDevice;
            std::vector<std::unique_ptr<ContextVulkan>> contexts;

            std::unique_ptr<Stage> drawStage;

            VkExtent2D displayExtent;
            VkPipelineCache pipelineCache;
    };
}}