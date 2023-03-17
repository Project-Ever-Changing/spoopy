#include <device/InstanceDevice.h>

#ifdef SPOOPY_VULKAN
namespace lime {
    #if defined(HX_WINDOWS) && !defined(SPOOPY_DEBUG_MESSENGER)
    const std::vector<const char*> InstanceDevice::validationLayers = {"VK_LAYER_LUNARG_standard_validation"};
    #else
    const std::vector<const char*> InstanceDevice::validationLayers = {"VK_LAYER_KHRONOS_validation"};
    #endif
    

    #if SPOOPY_DEBUG_MESSENGER
    VKAPI_ATTR VkBool32 VKAPI_CALL CallbackDebug(VkDebugUtilsMessageSeverityFlagBitsEXT messageSeverity, VkDebugUtilsMessageTypeFlagsEXT messageTypes, 
        const VkDebugUtilsMessengerCallbackDataEXT *pCallbackData, void *pUserData) {
            if(messageSeverity & VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT) {
                SPOOPY_LOG_WARN(pCallbackData - >pMessage);
            }else if(messageSeverity &  VK_DEBUG_UTILS_MESSAGE_SEVERITY_INFO_BIT_EXT) {
                SPOOPY_LOG_INFO(pCallbackData -> pMessage);
            }else {
                SPOOPY_LOG_ERROR(pCallbackData->pMessage);
            }
    }
    #else
    VKAPI_ATTR VkBool32 VKAPI_CALL CallbackDebug(VkDebugReportFlagsEXT flags, VkDebugReportObjectTypeEXT objectType, uint64_t object, size_t location, int32_t messageCode,
	const char *pLayerPrefix, const char *pMessage, void *pUserData) {
        if(flags & VK_DEBUG_REPORT_WARNING_BIT_EXT) {
            SPOOPY_LOG_WARN(pMessage);
        }else if(flags & VK_DEBUG_REPORT_INFORMATION_BIT_EXT) {
            SPOOPY_LOG_INFO(pMessage);
        }else {
            SPOOPY_LOG_ERROR(pMessage);
        }

        return VK_FALSE;
    }
    #endif

    InstanceDevice::InstanceDevice(SpoopyWindowSurface &window): window(window) {
        /*
        * Empty
        */
    }

    InstanceDevice::~InstanceDevice() {
        #if SPOOPY_DEBUG_MESSENGER
        FvkDestroyDebugUtilsMessengerEXT(instance, debugMessenger, nullptr);
        #else
        FvkDestroyDebugReportCallbackEXT(instance, debugReportCallback, nullptr);
        #endif

        vkDestroyInstance(instance, nullptr);
    }

    bool InstanceDevice::checkValidationLayerSupport() const {
        uint32_t count;
	    vkEnumerateInstanceLayerProperties(&count, nullptr);

	    std::vector<VkLayerProperties> instanceLayerProperties(count);
	    vkEnumerateInstanceLayerProperties(&count, instanceLayerProperties.data());

        for(const auto &layerName: validationLayers) {
            bool layerFound = false;

            for(const auto &layerProperties: instanceLayerProperties) {
                if(strcmp(layerName, layerProperties.layerName) == 0) {
                    layerFound = true;
                    break;
                }
            }

            if(!layerFound) {
                SPOOPY_LOG_WARN("Vulkan Validation Layer Not Found");
                return false;
            }
        }

        return true;
    }

    void InstanceDevice::createInstance(const char* name, const int version[3]) {
        VkApplicationInfo applicationInfo = {};
        applicationInfo.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
        applicationInfo.pApplicationName = name;
        applicationInfo.applicationVersion = VK_MAKE_VERSION(version[0], version[1], version[2]);
        applicationInfo.pEngineName = "Spoopy Engine";
        applicationInfo.engineVersion = VK_MAKE_VERSION(0, 0, 1);
        applicationInfo.apiVersion = volkGetInstanceVersion() >= VK_API_VERSION_1_1 ? VK_API_VERSION_1_1 : VK_MAKE_VERSION(1, 0, 57);

        if(enableValidationLayers && !checkValidationLayerSupport()) {
            SPOOPY_LOG_WARN("Validation layers not available!");
            enableValidationLayers = false;
        }

        auto extensions = getInstanceExtensions();

        VkInstanceCreateInfo instanceCreateInfo = {};
	    instanceCreateInfo.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
	    instanceCreateInfo.pApplicationInfo = &applicationInfo;
	    instanceCreateInfo.enabledExtensionCount = static_cast<uint32_t>(extensions.size());
	    instanceCreateInfo.ppEnabledExtensionNames = extensions.data();

        #if SPOOPY_DEBUG_MESSENGER
            VkDebugUtilsMessengerCreateInfoEXT debugUtilsMessengerCreateInfo = {};
        #endif

        if(enableValidationLayers) {
            #if SPOOPY_DEBUG_MESSENGER
            debugUtilsMessengerCreateInfo.sType = VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT;
            debugUtilsMessengerCreateInfo.messageSeverity = VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT | VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT | 
                VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT;
            debugUtilsMessengerCreateInfo.messageType = VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT | VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT | 
                VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT;
            debugUtilsMessengerCreateInfo.pfnUserCallback = &CallbackDebug;
            instanceCreateInfo.pNext = static_cast<VkDebugUtilsMessengerCreateInfoEXT *>(&debugUtilsMessengerCreateInfo);
            #endif

            instanceCreateInfo.enabledLayerCount = static_cast<uint32_t>(validationLayers.size());
            instanceCreateInfo.ppEnabledLayerNames = validationLayers.data();
        }

        checkVulkan(vkCreateInstance(&instanceCreateInfo, nullptr, &instance));

        #if VOLK_HEADER_VERSION >= 131
        volkLoadInstanceOnly(instance);
        #else
        volkLoadInstance(instance);
        #endif
    }

    void InstanceDevice::createDebugMessenger() {
        if(!enableValidationLayers) {
            return;
        }

        #if SPOOPY_DEBUG_MESSENGER
        VkDebugUtilsMessengerCreateInfoEXT debugUtilsMessengerCreateInfo = {};

        debugUtilsMessengerCreateInfo.sType = VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT;
        debugUtilsMessengerCreateInfo.messageSeverity = VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT | VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT | 
            VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT;
        debugUtilsMessengerCreateInfo.messageType = VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT | VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT | 
            VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT;
        debugUtilsMessengerCreateInfo.pfnUserCallback = &CallbackDebug;
        Graphics::CheckVk(FvkCreateDebugUtilsMessengerEXT(instance, &debugUtilsMessengerCreateInfo, nullptr, &debugMessenger));
        #else
        VkDebugReportCallbackCreateInfoEXT debugReportCallbackCreateInfo = {};

        debugReportCallbackCreateInfo.sType = VK_STRUCTURE_TYPE_DEBUG_REPORT_CALLBACK_CREATE_INFO_EXT;
        debugReportCallbackCreateInfo.pNext = nullptr;
        debugReportCallbackCreateInfo.flags = VK_DEBUG_REPORT_ERROR_BIT_EXT | VK_DEBUG_REPORT_WARNING_BIT_EXT | VK_DEBUG_REPORT_PERFORMANCE_WARNING_BIT_EXT;
        debugReportCallbackCreateInfo.pfnCallback = &CallbackDebug;
        debugReportCallbackCreateInfo.pUserData = nullptr;

        auto debugReportResult = FvkCreateDebugReportCallbackEXT(instance, &debugReportCallbackCreateInfo, nullptr, &debugReportCallback);

        if (debugReportResult == VK_ERROR_EXTENSION_NOT_PRESENT) {
            enableValidationLayers = false;
            SPOOPY_LOG_ERROR("Extension vkCreateDebugReportCallbackEXT not present!");
        } else {
            checkVulkan(debugReportResult);
        }
        #endif
    }

    std::vector<const char*> InstanceDevice::getInstanceExtensions() const {
        #ifdef SPOOPY_SDL
        unsigned int extensionCount = 0;
        SDL_Vulkan_GetInstanceExtensions(window.getWindow().sdlWindow, &extensionCount, nullptr);

        std::vector<const char*> extensions(extensionCount);
        SDL_Vulkan_GetInstanceExtensions(window.getWindow().sdlWindow, &extensionCount, extensions.data());

        if(enableValidationLayers) {
            extensions.emplace_back(VK_EXT_DEBUG_UTILS_EXTENSION_NAME);
            extensions.emplace_back(VK_EXT_DEBUG_REPORT_EXTENSION_NAME);
        }
        #else
        std::vector<const char*> extensions();
        #endif

        return extensions;
    }
}
#endif