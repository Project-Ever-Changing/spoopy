#ifndef SPOOPY_INSTANCE_DEVICE_H
#define SPOOPY_INSTANCE_DEVICE_H

#include <vector>
#include <set>

#include <ui/SpoopyWindow.h>

namespace spoopy {
    #ifdef SPOOPY_VULKAN
        #ifdef SPOOPY_DEBUG_MESSENGER
        static VKAPI_ATTR VkBool32 VKAPI_CALL CallbackDebug(VkDebugUtilsMessageSeverityFlagBitsEXT messageSeverity, VkDebugUtilsMessageTypeFlagsEXT messageTypes, 
        const VkDebugUtilsMessengerCallbackDataEXT *pCallbackData, void *pUserData);
        #else
        static VKAPI_ATTR VkBool32 VKAPI_CALL CallbackDebug(VkDebugReportFlagsEXT flags, VkDebugReportObjectTypeEXT objectType, uint64_t object, size_t location, int32_t messageCode,
		const char *pLayerPrefix, const char *pMessage, void *pUserData);
        #endif
    #endif

    class InstanceDevice {
        public:
            InstanceDevice(const SpoopyWindow &window);
            virtual ~InstanceDevice();

            virtual void createInstance(const char* name, const int version[3]);
            virtual void createDebugMessenger();
            virtual const bool getEnabledValidationLayers() const;

            #ifdef SPOOPY_VULKAN
            virtual bool getAvailableVulkanExtensions(std::vector<const char*>& outExtensions);

            virtual const VkInstance &getInstance() const {return instance;}
            #endif
        private:
            const SpoopyWindow &window;

            #ifdef SPOOPY_DEBUG
            const bool enableValidationLayers = false;
            #else
            const bool enableValidationLayers = true;
            #endif

            #ifdef SPOOPY_VULKAN
            virtual uint32_t getAPIVersion();

            VkInstance instance = VK_NULL_HANDLE;

            #ifdef SPOOPY_DEBUG_MESSENGER
            VkDebugUtilsMessengerEXT debugMessenger = VK_NULL_HANDLE;
            #else
            VkDebugReportCallbackEXT debugReportCallback = VK_NULL_HANDLE;
            #endif

            const std::vector<const char*> validationLayers = {"VK_LAYER_KHRONOS_validation"};
            #endif
    };
}
#endif