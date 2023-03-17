#pragma once

#include <vector>
#include <set>

#include <helpers/SpoopyHelpers.h>
#include <ui/SpoopyWindowSurface.h>

#ifdef SPOOPY_VULKAN
namespace lime {
    #ifdef SPOOPY_DEBUG_MESSENGER
    static VKAPI_ATTR VkBool32 VKAPI_CALL CallbackDebug(VkDebugUtilsMessageSeverityFlagBitsEXT messageSeverity, VkDebugUtilsMessageTypeFlagsEXT messageTypes, 
    const VkDebugUtilsMessengerCallbackDataEXT *pCallbackData, void *pUserData);
    #else
    static VKAPI_ATTR VkBool32 VKAPI_CALL CallbackDebug(VkDebugReportFlagsEXT flags, VkDebugReportObjectTypeEXT objectType, uint64_t object, size_t location, int32_t messageCode,
    const char *pLayerPrefix, const char *pMessage, void *pUserData);
    #endif

    class InstanceDevice {
        public:
            InstanceDevice(SpoopyWindowSurface &window);
            virtual ~InstanceDevice();

            virtual void createInstance(const char* name, const int version[3]);
            virtual void createDebugMessenger();

            virtual bool getEnableValidationLayers() const {return enableValidationLayers;}
            virtual const VkInstance &getInstance() const {return instance;}
        private:
            SpoopyWindowSurface &window;

            #if defined(SPOOPY_DEBUG)
            bool enableValidationLayers = false;
            #else
            bool enableValidationLayers = true;
            #endif

            std::vector<const char*> getInstanceExtensions() const;

            virtual bool checkValidationLayerSupport() const;

            VkInstance instance = VK_NULL_HANDLE;

            #ifdef SPOOPY_DEBUG_MESSENGER
            VkDebugUtilsMessengerEXT debugMessenger = VK_NULL_HANDLE;
            #else
            VkDebugReportCallbackEXT debugReportCallback = VK_NULL_HANDLE;
            #endif

            static const std::vector<const char*> validationLayers;
    };
}
#endif