#include <device/DeviceManager.h>

namespace spoopy {
    #ifdef SPOOPY_VULKAN
    void DeviceManager::initAppWithVulkan(std::string name, unsigned int version[3]) {
        if(enableLayerSupport && !checkLayerSupportForVulkan()) {
            throw std::runtime_error("validation layers requested, but not available!");
        }

        VkApplicationInfo appInfo = {};
        appInfo.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
        appInfo.pApplicationName = name.c_str();
        appInfo.applicationVersion = VK_MAKE_VERSION(version[0], version[1], version[2]);
        appInfo.pEngineName = "Spoopy Engine";
        appInfo.engineVersion = VK_MAKE_VERSION(1, 0, 0);
        appInfo.apiVersion = VK_API_VERSION_1_0;

        VkInstanceCreateInfo info = {};
        info.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
        info.pApplicationInfo = &appInfo;

        //auto extensions 
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

    std::vector<const char*> DeviceManager::getRequiredExtensions() {
        unsigned int count;

        std::vector<const char*> extensions = {};

        if(enableLayerSupport) {
            extensions.push_back(VK_EXT_DEBUG_REPORT_EXTENSION_NAME);
        }

        return extensions;
    }
    #endif

    DeviceManager::~DeviceManager() {
        //empty for now.
    }
}