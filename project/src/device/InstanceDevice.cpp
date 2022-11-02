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
        #else
        VKAPI_ATTR VkBool32 VKAPI_CALL CallbackDebug(VkDebugReportFlagsEXT flags, VkDebugReportObjectTypeEXT objectType, uint64_t object, size_t location, int32_t messageCode,
        const char *pLayerPrefix, const char *pMessage, void *pUserData) {
            if (flags & VK_DEBUG_REPORT_WARNING_BIT_EXT) {
                SPOOPY_LOG_WARN(pMessage, '\n');
            }else if (flags & VK_DEBUG_REPORT_INFORMATION_BIT_EXT) {
                SPOOPY_LOG_INFO(pMessage, '\n');
            }else {
                SPOOPY_LOG_ERROR(pMessage, '\n');
            }

            return VK_FALSE;
        }
        #endif
    #endif

    InstanceDevice::InstanceDevice(const Window &window): window(window) {
        //empty
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

    void InstanceDevice::createDebugMessenger() {
        #ifdef SPOOPY_VULKAN
            if(!enableValidationLayers) {
                return;
            }

            #ifdef SPOOPY_DEBUG_MESSENGER
            VkDebugUtilsMessengerCreateInfoEXT debugUtilsMessengerCreateInfo = {};
            debugUtilsMessengerCreateInfo.sType = VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT;
            debugUtilsMessengerCreateInfo.messageSeverity = VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT | VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT | 
                VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT;
            debugUtilsMessengerCreateInfo.messageType = VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT | VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT | 
                VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT;
            debugUtilsMessengerCreateInfo.pfnUserCallback = &CallbackDebug;
            checkVulkan(FvkCreateDebugUtilsMessengerEXT(instance, &debugUtilsMessengerCreateInfo, nullptr, &debugMessenger));
            #else
            VkDebugReportCallbackCreateInfoEXT debugReportCallbackCreateInfo = {};
            debugReportCallbackCreateInfo.sType = VK_STRUCTURE_TYPE_DEBUG_REPORT_CALLBACK_CREATE_INFO_EXT;
            debugReportCallbackCreateInfo.pNext = nullptr;
            debugReportCallbackCreateInfo.flags = VK_DEBUG_REPORT_ERROR_BIT_EXT | VK_DEBUG_REPORT_WARNING_BIT_EXT | VK_DEBUG_REPORT_PERFORMANCE_WARNING_BIT_EXT;
            debugReportCallbackCreateInfo.pfnCallback = &CallbackDebug;
            debugReportCallbackCreateInfo.pUserData = nullptr;
            auto debugReportResult = FvkCreateDebugReportCallbackEXT(instance, &debugReportCallbackCreateInfo, nullptr, &debugReportCallback);
            checkVulkan(debugReportResult);
            #endif
        #endif
    }

    const bool InstanceDevice::getEnabledValidationLayers() const {
        return enableValidationLayers;
    }

    InstanceDevice::~InstanceDevice() {
        #ifdef SPOOPY_VULKAN
            #ifdef SPOOPY_DEBUG_MESSENGER
            FvkDestroyDebugUtilsMessengerEXT(instance, debugMessenger, nullptr);
            #else
            FvkDestroyDebugReportCallbackEXT(instance, debugReportCallback, nullptr);
            #endif

            vkDestroyInstance(instance, nullptr);
        #endif
    }

    #ifdef SPOOPY_VULKAN
    bool InstanceDevice::getAvailableVulkanExtensions(std::vector<const char*>& outExtensions) {
        int32_t ext_count = 0;

        ext_count = window.getExtensionCount();

        if(ext_count < 0) {
            return false;
        }

        std::vector<const char*> ext_names(ext_count);
        ext_names = window.getInstanceExtensions(ext_count);

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