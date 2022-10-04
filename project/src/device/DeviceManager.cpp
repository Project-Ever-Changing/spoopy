#include <device/DeviceManager.h>

namespace spoopy {
    #ifdef SPOOPY_VULKAN
    void DeviceManager::initAppWithVulkan(std::string name) {
    
    }

    bool DeviceManager::checkLayerSupportForVulkan() {
        uint32_t layers;

        vkEnumerateInstanceLayerProperties(&layers, nullptr);

        std::vector<VkLayerProperties> aLayers;
        vkEnumerateInstanceLayerProperties(&layers, aLayers.data());

        for(const char *layerName: validationLayers) {
            bool layerFound = false;

            for(const auto &layerProps: aLayers) {
                if (strcmp(layerName, layerProps.layerName) == 0) {
                    layerFound = true;
                    break;
                }
            }

            if (!layerFound) {
                return false;
            }
        }

        return true;
    }
    #endif

    DeviceManager::~DeviceManager() {
        //empty for now.
    }
}