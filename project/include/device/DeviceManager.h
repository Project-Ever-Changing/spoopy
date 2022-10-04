#ifndef SPOOPY_DEVICE_MANAGER_H
#define SPOOPY_DEVICE_MANAGER_H

#include <string>
#include <vector>

#include "WindowDevice.h"

namespace spoopy {
    class DeviceManager {
        public:
            virtual ~DeviceManager();

            const bool enableLayerSupport = true;

            #ifdef SPOOPY_VULKAN
            virtual void initAppWithVulkan(std::string name, unsigned int version[3]);
            virtual bool checkLayerSupportForVulkan();
            virtual std::vector<const char*> getRequiredExtensions();
            #endif
        private:
            #ifdef SPOOPY_VULKAN
            const std::vector<const char*> validationLayers = {"VK_LAYER_KHRONOS_validation"};
            #endif
    };
}
#endif