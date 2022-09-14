#ifndef SPOOPY_DEVICE_MANAGER_H
#define SPOOPY_DEVICE_MANAGER_H

#include <string>

#include "WindowDevice.h"

namespace spoopy {
    class DeviceManager {
        public:
            virtual ~DeviceManager();

            #ifdef SPOOPY_VULKAN
            virtual void initAppWithVulkan(std::string name);
            virtual bool checkLayerSupportForVulkan();
            #endif
    };
}
#endif