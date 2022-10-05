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

        auto extensions = getRequiredExtensions();
        info.enabledExtensionCount = static_cast<uint32_t>(extensions.size());
        info.ppEnabledExtensionNames = extensions.data();

        VkDebugUtilsMessengerCreateInfoEXT debugInfo = {};

        if(enableLayerSupport) {
            info.enabledLayerCount = static_cast<uint32_t>(validationLayers.size());
            info.ppEnabledExtensionNames = validationLayers.data();

            populateDebugMessageVulkan(debugInfo);
            info.pNext = (VkDebugUtilsMessengerCreateInfoEXT*)&debugInfo;
        }else {
            info.enabledLayerCount = 0;
            info.pNext = nullptr;
        }

        if (vkCreateInstance(&info, nullptr, &instance) != VK_SUCCESS) {
            throw std::runtime_error("failed to create instance!");
        }
    }

    void DeviceManager::populateDebugMessageVulkan(VkDebugUtilsMessengerCreateInfoEXT &info) {
        info.sType = VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT;
        info.messageSeverity = VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT |
                                    VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT;
        info.messageType = VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT |
                                VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT |
                                VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT;
        info.pfnUserCallback = debugCallback;
        info.pUserData = nullptr;
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