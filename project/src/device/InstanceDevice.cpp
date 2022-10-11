#include <device/InstanceDevice.h>

namespace spoopy {
    #ifdef SPOOPY_VULKAN
        #ifdef SPOOPY_DEBUG_MESSENGER
        VKAPI_ATTR VkBool32 VKAPI_CALL CallbackDebug(VkDebugUtilsMessageSeverityFlagBitsEXT messageSeverity, VkDebugUtilsMessageTypeFlagsEXT messageTypes, 
        const VkDebugUtilsMessengerCallbackDataEXT *pCallbackData, void *pUserData) {
            if (messageSeverity & VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT) {
                SPOOPY_LOG_WARN(pCallbackData->pMessage, '\n');
            }else if (messageSeverity &  VK_DEBUG_UTILS_MESSAGE_SEVERITY_INFO_BIT_EXT) {
                SPOOPY_LOG_INFO(pCallbackData->pMessage, '\n');
            }else {
                SPOOPY_LOG_ERROR(pCallbackData->pMessage, '\n');
            }

            return VK_FALSE;
        }
        #endif
    #endif

    InstanceDevice::InstanceDevice(Window* window) {
        this -> window = window;
    }

    void InstanceDevice::createInstance(const char* name, const int version[3]) {
        #ifdef SPOOPY_VULKAN
        VkApplicationInfo appInfo = {};
        appInfo.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
        appInfo.pApplicationName = name;
        appInfo.applicationVersion = VK_MAKE_VERSION(version[0], version[1], version[2]);
        appInfo.pEngineName = "Spoopy Engine";
        appInfo.engineVersion = VK_MAKE_VERSION(1, 0, 0);
        appInfo.apiVersion = getAPIVersion();

        if(enableValidationLayers) {
            throw "Validation layers requested, but not available!\n";
        }

        std::vector<const char*> extensions;
        if(!getAvailableVulkanExtensions(extensions)) {
            throw "Unable to find any extensions";
        }

        VkInstanceCreateInfo instanceInfo = {};
        instanceInfo.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
        instanceInfo.pApplicationInfo = &appInfo;
        instanceInfo.enabledExtensionCount = static_cast<uint32_t>(extensions.size());
        instanceInfo.ppEnabledExtensionNames = extensions.data();

        #ifdef SPOOPY_DEBUG_MESSENGER
        VkDebugUtilsMessengerCreateInfoEXT debugUtilsMessengerCreateInfo = {};
        #endif

        if(enableValidationLayers) {
            #ifdef SPOOPY_DEBUG_MESSENGER
            debugUtilsMessengerCreateInfo.sType = VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT;
            debugUtilsMessengerCreateInfo.messageSeverity = VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT | VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT | 
                VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT;
            debugUtilsMessengerCreateInfo.messageType = VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT | VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT | 
                VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT;
            debugUtilsMessengerCreateInfo.pfnUserCallback = &CallbackDebug;
            instanceInfo.pNext = static_cast<VkDebugUtilsMessengerCreateInfoEXT *>(&debugUtilsMessengerCreateInfo);
            #endif

            instanceInfo.enabledLayerCount = static_cast<uint32_t>(validationLayers.size());
		    instanceInfo.ppEnabledLayerNames = validationLayers.data();
        }

        checkVulkan(vkCreateInstance(&instanceInfo, nullptr, &instance));
        #endif
    }

    bool InstanceDevice::getEnabledValidationLayers() const {
        return enableValidationLayers;
    }

    InstanceDevice::~InstanceDevice() {

    }

    #ifdef SPOOPY_VULKAN
    bool InstanceDevice::getAvailableVulkanExtensions(std::vector<const char*>& outExtensions) {
        uint32_t ext_count = 0;

        if(window == nullptr) {
            throw "Unable to find window.";
        }

        if(window -> sdlWindow == nullptr) {
            throw "Unable to find SDL window.";
        }

        if(!SDL_Vulkan_GetInstanceExtensions(window -> sdlWindow, &ext_count, nullptr)) {
            std::cout << "Unable to query the number of Vulkan instance extensions\n";
            return false;
        }

        std::vector<const char*> ext_names(ext_count);
        if (!SDL_Vulkan_GetInstanceExtensions(window -> sdlWindow, &ext_count, ext_names.data())) {
            std::cout << "Unable to query the number of Vulkan instance extension names\n";
            return false;
        }

        for (uint32_t i = 0; i < ext_count; i++) {
            outExtensions.emplace_back(ext_names[i]);
        }

        outExtensions.emplace_back(VK_EXT_DEBUG_REPORT_EXTENSION_NAME);
        return true;
    }

    uint32_t InstanceDevice::getAPIVersion() {
        #if defined(VK_VERSION_1_1)
        uint32_t api_version = 0;

        if(vkEnumerateInstanceVersion(&api_version) == VK_SUCCESS) {
            return api_version;
        }
        #endif

        return VK_MAKE_VERSION(1, 0, 57);
    }
    #endif
}