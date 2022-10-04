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
            virtual void initAppWithVulkan(std::string name);
            virtual bool checkLayerSupportForVulkan();
            #endif
        private:
            const std::vector<const char*> validationLayers = {"VK_LAYER_KHRONOS_validation"};
    };
}
#endif