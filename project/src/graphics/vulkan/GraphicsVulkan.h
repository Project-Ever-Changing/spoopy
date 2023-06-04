#pragma once

#include "../../device/Instance.h"
#include "../../device/LogicalDevice.h"
#include "../../device/PhysicalDevice.h"
#include "ContextVulkan.h"

#include <sdl_definitions_config.h>
#include <vector>

namespace lime {
    class GraphicsVulkan {
        public:
            friend class GraphicsHandler;

            GraphicsVulkan(SDL_Window* m_window);
            ~GraphicsVulkan();

            static const GraphicsVulkan* GetCurrent() { return Main; }
            const PhysicalDevice *GetPhysicalDevice() const { return physicalDevice.get(); }
            const LogicalDevice *GetLogicalDevice() const { return logicalDevice.get(); }
            const VkPipelineCache &GetPipelineCache() const { return pipelineCache; }
        private:
            static GraphicsVulkan* Main;

            std::unique_ptr<Instance> instance;
            std::unique_ptr<PhysicalDevice> physicalDevice;
            std::unique_ptr<LogicalDevice> logicalDevice;
            std::vector<std::unique_ptr<ContextVulkan>> contexts;

            VkPipelineCache pipelineCache;
    };
}