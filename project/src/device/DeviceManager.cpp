#include <device/DeviceManager.h>

namespace spoopy {
    #ifdef SPOOPY_VULKAN
    void DeviceManager::initAppWithVulkan(std::string name) {
    
    }

    bool DeviceManager::checkLayerSupportForVulkan() {
        uint32_t layers;

        //vkEnumerateInstanceLayerProperties(&layers, nullptr);
        return true;
    }
    #endif

    DeviceManager::~DeviceManager() {
        //empty for now.
    }
}