#include "Instance.h"

#include <sstream>
#include <string>

namespace lime {
    Instance::Instance(SDL_Window* window): m_window(window) {
        #ifdef SPOOPY_DEBUG
        enableValidationLayers = true;
        #endif

        CreateInstance();
        CreateDebugMessenger();
    }

    Instance::~Instance() {
        #ifdef SPOOPY_DEBUG_MESSENGER
        FvkDestroyDebugUtilsMessengerEXT(instance, debugMessenger, nullptr);
        #else
        FvkDestroyDebugReportCallbackEXT(instance, debugMessenger, nullptr);
        #endif

        vkDestroyInstance(instance, nullptr);
        m_window = nullptr;
    }

    void Instance::CreateInstance() {
        checkVulkan(volkInitialize());

        VkApplicationInfo applicationInfo = {};
        applicationInfo.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
        applicationInfo.pEngineName = "Spoopy";
        applicationInfo.engineVersion = SPOOPY_ENGINE_VERSION;
        applicationInfo.apiVersion = volkGetInstanceVersion() >= VK_API_VERSION_1_1 ? VK_API_VERSION_1_1 : VK_MAKE_VERSION(1, 0, 57);

        if(enableValidationLayers && !CheckValidationLayerSupport()) {
            SPOOPY_LOG_ERROR("Vulkan validation layers requested, but not available!");
            enableValidationLayers = false;
        }

        auto extensions = GetExtensions();

        VkInstanceCreateInfo instanceCreateInfo = {};
        instanceCreateInfo.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
        instanceCreateInfo.pApplicationInfo = &applicationInfo;
        instanceCreateInfo.enabledExtensionCount = static_cast<uint32_t>(extensions.size());
        instanceCreateInfo.ppEnabledExtensionNames = extensions.data();

        #if SPOOPY_DEBUG_MESSENGER
            VkDebugUtilsMessengerCreateInfoEXT debugUtilsMessengerCreateInfo = {};
        #endif

        if (enableValidationLayers) {
            #if USE_DEBUG_MESSENGER
                debugUtilsMessengerCreateInfo.sType = VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT;
                debugUtilsMessengerCreateInfo.messageSeverity = VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT | VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT |
                        VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT;
                debugUtilsMessengerCreateInfo.messageType = VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT | VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT |
                        VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT;
                debugUtilsMessengerCreateInfo.pfnUserCallback = &Devices::DebugCallback;
                instanceCreateInfo.pNext = static_cast<VkDebugUtilsMessengerCreateInfoEXT *>(&debugUtilsMessengerCreateInfo);
            #endif

            instanceCreateInfo.enabledLayerCount = static_cast<uint32_t>(ValidationLayers.size());
            instanceCreateInfo.ppEnabledLayerNames = ValidationLayers.data();
        }

        checkVulkan(vkCreateInstance(&instanceCreateInfo, nullptr, &instance));

        #if VOLK_HEADER_VERSION >= 131
            volkLoadInstanceOnly(instance);
        #else
            volkLoadInstance(instance);
        #endif
    }

    void Instance::CreateDebugMessenger() {
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
            debugUtilsMessengerCreateInfo.pfnUserCallback = &Devices::DebugCallback;

            checkVulkan(FvkCreateDebugUtilsMessengerEXT(instance, &debugUtilsMessengerCreateInfo, nullptr, &debugMessenger));
        #else
            VkDebugReportCallbackCreateInfoEXT debugReportCallbackCreateInfo = {};
            debugReportCallbackCreateInfo.sType = VK_STRUCTURE_TYPE_DEBUG_REPORT_CALLBACK_CREATE_INFO_EXT;
            debugReportCallbackCreateInfo.pNext = nullptr;
            debugReportCallbackCreateInfo.flags = VK_DEBUG_REPORT_ERROR_BIT_EXT | VK_DEBUG_REPORT_WARNING_BIT_EXT | VK_DEBUG_REPORT_PERFORMANCE_WARNING_BIT_EXT;
            debugReportCallbackCreateInfo.pfnCallback = &Devices::DebugCallback;
            debugReportCallbackCreateInfo.pUserData = nullptr;
            auto debugReportResult = FvkCreateDebugReportCallbackEXT(instance, &debugReportCallbackCreateInfo, nullptr, &debugMessenger);

            if (debugReportResult == VK_ERROR_EXTENSION_NOT_PRESENT) {
                enableValidationLayers = false;
                SPOOPY_LOG_ERROR("Extension vkCreateDebugReportCallbackEXT not present!");
            } else {
                checkVulkan(debugReportResult);
            }
        #endif
    }

    bool Instance::CheckValidationLayerSupport() const {
        uint32_t count;
        vkEnumerateInstanceLayerProperties(&count, nullptr);

        std::vector<VkLayerProperties> instanceLayerProperties(count);
        vkEnumerateInstanceLayerProperties(&count, instanceLayerProperties.data());

        for(const char* layerName : Devices::ValidationLayers) {
            bool layerFound = false;

            for(const auto& layerProperties : instanceLayerProperties) {
                if(strcmp(layerName, layerProperties.layerName) == 0) {
                    layerFound = true;
                    break;
                }
            }

            if(!layerFound) {
                std::ostringstream msg;
                msg << "Vulkan validation layer not found: \"" << layerName << "\"\n";

                SPOOPY_LOG_ERROR(msg.str());
                return false;
            }
        }

        return true;
    }

    std::vector<const char *> Instance::GetExtensions() const {
        #ifdef SPOOPY_SDL
                unsigned int extensionCount = 0;
                SDL_Vulkan_GetInstanceExtensions(m_window, &extensionCount, nullptr);
                std::vector<const char*> extensions(extensionCount);
                SDL_Vulkan_GetInstanceExtensions(m_window, &extensionCount, extensions.data());

                if(enableValidationLayers) {
                    extensions.emplace_back(VK_EXT_DEBUG_UTILS_EXTENSION_NAME);
                    extensions.emplace_back(VK_EXT_DEBUG_REPORT_EXTENSION_NAME);
                }
        #else
                std::vector<const char*> extensions;
        #endif

        return extensions;
    }
}