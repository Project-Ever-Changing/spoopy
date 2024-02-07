#include "Instance.h"
#include "Extensions.h"
#include "MacVulkanBindings.h"

#include <spoopy.h>

#include <utility>
#include <sstream>
#include <stack>

#ifndef VK_EXT_DEBUG_UTILS_EXTENSION_NAME
#define VK_EXT_DEBUG_UTILS_EXTENSION_NAME "VK_EXT_debug_utils"
#endif

namespace lime { namespace spoopy {
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

        if (flags & VK_DEBUG_REPORT_WARNING_BIT_EXT || flags & VK_DEBUG_REPORT_PERFORMANCE_WARNING_BIT_EXT) {
            SPOOPY_LOG_WARN(pMessage);
        }else if (flags & VK_DEBUG_REPORT_INFORMATION_BIT_EXT || flags & VK_DEBUG_REPORT_DEBUG_BIT_EXT) {
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
        #if defined(__APPLE__)

        // So that MoltenVK can be used on macOS, we need to set the VK_ICD_FILENAMES environment variable to point to the MoltenVK_icd.json file
        // Else it go boom boom (Not really but it won't work)
	spoopy_mac::SetICDEnv();
        #endif


        #if !defined(SPOOPY_SWITCH)
        checkVulkan(volkInitialize());
        #endif

        uint32_t volkVersion = volkGetInstanceVersion();

        if(volkVersion < VK_API_VERSION_1_2) {
            SPOOPY_LOG_ERROR("Vulkan version is too low! Please update your Vulkan drivers to at least version 1.2!");
            return;
        }


        VkApplicationInfo applicationInfo = {};
        applicationInfo.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
        applicationInfo.pEngineName = "spoopy";
        applicationInfo.engineVersion = SPOOPY_ENGINE_VERSION;
        applicationInfo.apiVersion =volkVersion >= VK_API_VERSION_1_3 ? VK_API_VERSION_1_3 : VK_API_VERSION_1_2;

        if(enableValidationLayers && !CheckValidationLayerSupport()) {
            SPOOPY_LOG_ERROR("Vulkan validation layers requested, but not available!");
            enableValidationLayers = false;
        }

        std::vector<const char*> extensions;
        uint32_t size = 0;
        GetExtensions(extensions, size);

        VkInstanceCreateInfo instanceCreateInfo = {};
        instanceCreateInfo.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
        instanceCreateInfo.pApplicationInfo = &applicationInfo;
        instanceCreateInfo.enabledExtensionCount = size;
        instanceCreateInfo.ppEnabledExtensionNames = extensions.data();

        #ifdef __APPLE__
            instanceCreateInfo.flags = VK_INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR;
        #endif

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

            AddValidationLayers(availableLayers, validationLayers);

            instanceCreateInfo.enabledLayerCount = static_cast<uint32_t>(validationLayers.size());
            instanceCreateInfo.ppEnabledLayerNames = validationLayers.data();
        }

        VkResult result = vkCreateInstance(&instanceCreateInfo, nullptr, &instance);
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

    bool Instance::CheckValidationLayerSupport() {
        if(!availableLayers.empty()) {
            SPOOPY_LOG_WARN("Validation layers already enumerated!");
            return false;
        }

        uint32_t count;
        vkEnumerateInstanceLayerProperties(&count, nullptr);
        std::vector<VkLayerProperties> instanceLayerProperties(count);
        vkEnumerateInstanceLayerProperties(&count, instanceLayerProperties.data());

        for(const char* layerName: validationLayers) {
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

        availableLayers = std::move(instanceLayerProperties);
        return true;
    }

    void Instance::GetExtensions(std::vector<const char*> &extensions, uint32_t &size) const {

        uint32_t availableExtensionCount = 0;
        vkEnumerateInstanceExtensionProperties(nullptr, &availableExtensionCount, nullptr);
        std::vector<VkExtensionProperties> availableExtensions(availableExtensionCount);
        vkEnumerateInstanceExtensionProperties(nullptr, &availableExtensionCount, availableExtensions.data());

        std::stack<const char*> extensionStack;

        for(const auto &extension: availableExtensions) {
            #define ADD_EXTENSION(name) \
                if(platform::stringCompare(extension.extensionName, name) == 0) { \
                    extensionStack.push(name); \
                    size++; \
                    continue; \
                }

            ADD_EXTENSION(VK_KHR_SURFACE_EXTENSION_NAME);

            #if VK_EXT_debug_utils
                ADD_EXTENSION(VK_EXT_DEBUG_UTILS_EXTENSION_NAME);
            #endif

            if(enableValidationLayers) {
                ADD_EXTENSION(VK_EXT_DEBUG_REPORT_EXTENSION_NAME);
            }

            #if defined(__APPLE__)
                ADD_EXTENSION(VK_KHR_GET_PHYSICAL_DEVICE_PROPERTIES_2_EXTENSION_NAME);
                ADD_EXTENSION(VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME);
                ADD_EXTENSION(VK_KHR_PORTABILITY_SUBSET_EXTENSION_NAME);
            #endif

            #if defined(VK_USE_PLATFORM_WIN32_KHR)
                ADD_EXTENSION(VK_KHR_WIN32_SURFACE_EXTENSION_NAME);
            #elif defined(VK_USE_PLATFORM_XCB_KHR)
                ADD_EXTENSION(VK_KHR_XCB_SURFACE_EXTENSION_NAME);
            #elif defined(VK_USE_PLATFORM_XLIB_KHR)
                ADD_EXTENSION(VK_KHR_XLIB_SURFACE_EXTENSION_NAME);
            #elif defined(VK_USE_PLATFORM_WAYLAND_KHR)
                ADD_EXTENSION(VK_KHR_WAYLAND_SURFACE_EXTENSION_NAME);
            #elif defined(VK_USE_PLATFORM_ANDROID_KHR)
                ADD_EXTENSION(VK_KHR_ANDROID_SURFACE_EXTENSION_NAME);
            #elif defined(VK_MVK_MACOS_SURFACE_EXTENSION_NAME)
                ADD_EXTENSION(VK_MVK_MACOS_SURFACE_EXTENSION_NAME);
            #elif defined(VK_MVK_IOS_SURFACE_EXTENSION_NAME)
                ADD_EXTENSION(VK_MVK_IOS_SURFACE_EXTENSION_NAME);
            #endif

            #undef ADD_EXTENSION
        }

        extensions.reserve(size);

        for(uint32_t i=0; i<size; i++) {
            extensions.emplace_back(extensionStack.top());
            extensionStack.pop();
        }
    }

    void Instance::AddValidationLayers(std::vector<VkLayerProperties> &availableLayers
    , std::vector<const char*> &validationLayers) {
        bool hasKnronosStandardValidation = false;
        bool hasLunarGValidation = false;

        #if VK_USE_KHRONOS_STANDARD_VALIDATION

        const char* vkLayerKhronosValidation = "VK_LAYER_KHRONOS_validation";
        hasKnronosStandardValidation = CheckLayerSupport(availableLayers, vkLayerKhronosValidation);

        if(hasKnronosStandardValidation) {
            validationLayers.push_back(vkLayerKhronosValidation);
            SPOOPY_LOG_INFO("Using Khronos standard validation layer.");
        }

        #endif

        #if VK_USE_LUNARG_VALIDATION

        if(!hasKnronosStandardValidation) {
            const char* vkLayerLunarGValidation = "VK_LAYER_LUNARG_standard_validation";
            hasLunarGValidation = CheckLayerSupport(availableLayers, vkLayerLunarGValidation);

            if(hasLunarGValidation) {
                validationLayers.push_back(vkLayerLunarGValidation);
                SPOOPY_LOG_INFO("Using LunarG standard validation layer.");
            }
        }

        #endif

        if(!hasKnronosStandardValidation && !hasLunarGValidation) {
            const std::vector<const char*> AvailableLayers = {
                    "VK_LAYER_GOOGLE_threading",
                    "VK_LAYER_LUNARG_parameter_validation",
                    "VK_LAYER_LUNARG_object_tracker",
                    "VK_LAYER_LUNARG_core_validation",
                    "VK_LAYER_GOOGLE_unique_objects"
            };

            for(auto &layer : AvailableLayers) {
                bool supported = CheckLayerSupport(availableLayers, layer);

                if(supported) {
                    validationLayers.push_back(layer);
                    SPOOPY_LOG_INFO("Using validation layer: " + std::string(layer));
                }
            }

            if(validationLayers.empty()) {
                SPOOPY_LOG_WARN("No validation layers found!");
            }
        }
    }

    bool Instance::CheckLayerSupport(const std::vector<VkLayerProperties> &layers, const char* layerName) {
        for(auto &layer : layers) {
            if(platform::stringCompare(layer.layerName, layerName) == 0) {
                return true;
            }
        }

        return false;
    }
}}
