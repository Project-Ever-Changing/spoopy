#include <device/DeviceManager.h>

namespace spoopy {
    #ifdef SPOOPY_VULKAN
    void DeviceManager::initAppWithVulkan(const char* name, int version[3]) {
        if(enableLayerSupport && !checkLayerSupportForVulkan()) {
            throw std::runtime_error("validation layers requested, but not available!");
        }

        VkApplicationInfo appInfo = {};
        appInfo.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
        appInfo.pApplicationName = name;
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

        hasRequiredInstanceExtensionsVulkan();
    }

    void DeviceManager::hasRequiredInstanceExtensionsVulkan() { //long name for a method lol.
        uint32_t count = 0;
        vkEnumerateInstanceExtensionProperties(nullptr, &count, nullptr);
        std::vector<VkExtensionProperties> extensions(count);
        vkEnumerateInstanceExtensionProperties(nullptr, &count, extensions.data());

        std::cout << "available extensions:" << std::endl;
        std::unordered_set<std::string> available;

        for(const auto& extension: extensions) {
            std::cout << "\t" << extension.extensionName << std::endl;
            available.insert(extension.extensionName);
        }

        std::cout << "required extensions:" << std::endl;
        auto requiredExtensions = getRequiredExtensions();

        for (const auto &extension: requiredExtensions) {
            std::cout << "\t" << extension << std::endl;

            if (available.find(extension) == available.end()) {
                throw std::runtime_error("Missing required SDL extensions");
            }
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