#include "Instance.h"
#include "Capabilities.h"

#include <spoopy.h>

#include <sstream>

#ifndef VK_EXT_DEBUG_UTILS_EXTENSION_NAME

#define VK_EXT_DEBUG_UTILS_EXTENSION_NAME "VK_EXT_debug_utils"

#endif

namespace lime { namespace spoopy {
    #if VK_HEADER_VERSION > 101
        const std::vector<const char*> Instance::ValidationLayers = {"VK_LAYER_KHRONOS_validation"};
    #else
        const std::vector<const char*> Instance::ValidationLayers = {"VK_LAYER_LUNARG_standard_validation"};
    #endif

    #if SPOOPY_DEBUG_MESSENGER
    VKAPI_ATTR VkBool32 VKAPI_CALL CallbackDebug(VkDebugUtilsMessageSeverityFlagBitsEXT messageSeverity, VkDebugUtilsMessageTypeFlagsEXT messageTypes,
        const VkDebugUtilsMessengerCallbackDataEXT *pCallbackData, void *pUserData) {

        if (messageSeverity & VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT) {
            SPOOPY_LOG_WARN(pCallbackData->pMessage);
        }else if (messageSeverity & VK_DEBUG_UTILS_MESSAGE_SEVERITY_INFO_BIT_EXT) {
            SPOOPY_LOG_INFO(pCallbackData->pMessage);
        }else {
            SPOOPY_LOG_ERROR(pCallbackData->pMessage);
        }

        return VK_FALSE;
    }
    #else
    VKAPI_ATTR VkBool32 VKAPI_CALL CallbackDebug(VkDebugReportFlagsEXT flags, VkDebugReportObjectTypeEXT objectType, uint64_t object, size_t location, int32_t messageCode,
        const char *pLayerPrefix, const char *pMessage, void *pUserData) {

        if (flags & VK_DEBUG_REPORT_WARNING_BIT_EXT) {
            SPOOPY_LOG_WARN(pMessage);
        }else if (flags & VK_DEBUG_REPORT_INFORMATION_BIT_EXT) {
            SPOOPY_LOG_INFO(pMessage);
        }else {
            SPOOPY_LOG_ERROR(pMessage);
        }

        return VK_FALSE;
    }
    #endif

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
        #if !defined(SPOOPY_SWITCH)
        checkVulkan(volkInitialize());
        #endif

        VkApplicationInfo applicationInfo = {};
        applicationInfo.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
        applicationInfo.pEngineName = "Spoopy";
        applicationInfo.engineVersion = SPOOPY_ENGINE_VERSION;
        applicationInfo.apiVersion = volkGetInstanceVersion();

        if(enableValidationLayers && !CheckValidationLayerSupport()) {
            SPOOPY_LOG_ERROR("Vulkan validation layers requested, but not available!");
            enableValidationLayers = false;
        }

        auto extensions = GetExtensions();

        VkInstanceCreateInfo instanceCreateInfo = {};
        instanceCreateInfo.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
        instanceCreateInfo.flags = VK_INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR;
        instanceCreateInfo.pApplicationInfo = &applicationInfo;
        instanceCreateInfo.enabledExtensionCount = static_cast<uint32_t>(extensions.size());
        instanceCreateInfo.ppEnabledExtensionNames = extensions.data();

        #ifdef SPOOPY_DEBUG_MESSENGER
            VkDebugUtilsMessengerCreateInfoEXT debugUtilsMessengerCreateInfo = {};
        #endif

        if (enableValidationLayers) {
            #ifdef SPOOPY_DEBUG_MESSENGER
                debugUtilsMessengerCreateInfo.sType = VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT;
                debugUtilsMessengerCreateInfo.messageSeverity = VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT | VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT |
                        VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT;
                debugUtilsMessengerCreateInfo.messageType = VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT | VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT |
                        VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT;
                debugUtilsMessengerCreateInfo.pfnUserCallback = &CallbackDebug;
                instanceCreateInfo.pNext = static_cast<VkDebugUtilsMessengerCreateInfoEXT *>(&debugUtilsMessengerCreateInfo);
            #endif

            instanceCreateInfo.enabledLayerCount = static_cast<uint32_t>(ValidationLayers.size());
            instanceCreateInfo.ppEnabledLayerNames = ValidationLayers.data();
        }

        SPOOPY_LOG_INFO("Creating Vulkan instance...");

        VkResult result = vkCreateInstance(&instanceCreateInfo, nullptr, &instance);

        SPOOPY_LOG_INFO("Vulkan instance created!");

        if(result == VK_ERROR_INCOMPATIBLE_DRIVER) {
            #if defined(__APPLE__)

                SPOOPY_LOG_ERROR("Cannot find Metal driver, please make sure MoltenVK is installed!");

            #else

                SPOOPY_LOG_ERROR("Cannot find a compatible Vulkan installable client driver (ICD)!");

            #endif

            return;
        }

        if(result != VK_SUCCESS) {
            checkVulkan(result);
            return;
        }

        #if VOLK_HEADER_VERSION >= 131 && !defined(SPOOPY_SWITCH)

            volkLoadInstanceOnly(instance);

        #elif !defined(SPOOPY_SWITCH)

            volkLoadInstance(instance);

        #endif
    }

    void Instance::CreateDebugMessenger() {
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

        for(const char* layerName: ValidationLayers) {
            bool layerFound = false;

            for(const auto& layerProperties: instanceLayerProperties) {
                if(platform::stringCompare(layerName, layerProperties.layerName) == 0) {
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
        uint32_t availableExtensionCount = 0;
        vkEnumerateInstanceExtensionProperties(nullptr, &availableExtensionCount, nullptr);
        std::vector<VkExtensionProperties> availableExtensions(availableExtensionCount);
        vkEnumerateInstanceExtensionProperties(nullptr, &availableExtensionCount, availableExtensions.data());

        std::vector<const char *> extensions(availableExtensionCount);

        for(const auto& extension: availableExtensions) {
            if(platform::stringCompare(extension.extensionName, VK_EXT_DEBUG_UTILS_EXTENSION_NAME) == 0
            && enableValidationLayers) {
                extensions.emplace_back(VK_EXT_DEBUG_UTILS_EXTENSION_NAME);
                SPOOPY_LOG_INFO("Using VK_EXT_debug_utils for Spoopy Engine");
                continue;
            }

            if(platform::stringCompare(extension.extensionName, VK_EXT_DEBUG_REPORT_EXTENSION_NAME) == 0
            && enableValidationLayers) {
                extensions.emplace_back(VK_EXT_DEBUG_REPORT_EXTENSION_NAME);
                SPOOPY_LOG_INFO("Using VK_EXT_debug_utils for Spoopy Engine");
                continue;
            }

            if(platform::stringCompare(extension.extensionName, VK_KHR_SURFACE_EXTENSION_NAME) == 0) {
                extensions.emplace_back(VK_KHR_SURFACE_EXTENSION_NAME);
                continue;
            }

            if(platform::stringCompare(extension.extensionName, VK_KHR_GET_PHYSICAL_DEVICE_PROPERTIES_2_EXTENSION_NAME) == 0
            && volkGetInstanceVersion() >= VK_API_VERSION_1_3) {
                extensions.emplace_back(VK_KHR_GET_PHYSICAL_DEVICE_PROPERTIES_2_EXTENSION_NAME);
                continue;
            }

            #if defined(__APPLE__)
            if(platform::stringCompare(extension.extensionName, "VK_KHR_portability_enumeration") == 0) {
                extensions.emplace_back("VK_KHR_portability_enumeration");
                continue;
            }

            if(platform::stringCompare(extension.extensionName, "VK_KHR_portability_subset") == 0) {
                extensions.emplace_back("VK_KHR_portability_subset");
                continue;
            }
            #endif

            #if defined(VK_USE_PLATFORM_WIN32_KHR)
                if(platform::stringCompare(extension.extensionName, VK_KHR_WIN32_SURFACE_EXTENSION_NAME) == 0) {
                    extensions.emplace_back(VK_KHR_WIN32_SURFACE_EXTENSION_NAME);
                    continue;
                }
            #elif defined(VK_USE_PLATFORM_XCB_KHR)
                if(platform::stringCompare(extension.extensionName, VK_KHR_XCB_SURFACE_EXTENSION_NAME) == 0) {
                    extensions.emplace_back(VK_KHR_XCB_SURFACE_EXTENSION_NAME);
                    continue;
                }
            #elif defined(VK_USE_PLATFORM_XLIB_KHR)
                if(platform::stringCompare(extension.extensionName, VK_KHR_XLIB_SURFACE_EXTENSION_NAME) == 0) {
                    extensions.emplace_back(VK_KHR_XLIB_SURFACE_EXTENSION_NAME);
                    continue;
                }
            #elif defined(VK_USE_PLATFORM_WAYLAND_KHR)
                if(platform::stringCompare(extension.extensionName, VK_KHR_WAYLAND_SURFACE_EXTENSION_NAME) == 0) {
                    extensions.emplace_back(VK_KHR_WAYLAND_SURFACE_EXTENSION_NAME);
                    continue;
                }
            #elif defined(VK_USE_PLATFORM_ANDROID_KHR)
                if(platform::stringCompare(extension.extensionName, VK_KHR_ANDROID_SURFACE_EXTENSION_NAME) == 0) {
                    extensions.emplace_back(VK_KHR_ANDROID_SURFACE_EXTENSION_NAME);
                    continue;
                }
            #elif defined(VK_USE_PLATFORM_MACOS_MVK)
                if(platform::stringCompare(extension.extensionName, VK_MVK_MACOS_SURFACE_EXTENSION_NAME) == 0) {
                    extensions.emplace_back(VK_MVK_MACOS_SURFACE_EXTENSION_NAME);
                    continue;
                }
            #elif defined(VK_USE_PLATFORM_IOS_MVK)
                if(platform::stringCompare(extension.extensionName, VK_MVK_IOS_SURFACE_EXTENSION_NAME) == 0) {
                    extensions.emplace_back(VK_MVK_IOS_SURFACE_EXTENSION_NAME);
                    continue;
                }
            #endif
        }

        return extensions;
    }
}}