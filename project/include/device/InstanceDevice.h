#ifndef SPOOPY_INSTANCE_DEVICE_H
#define SPOOPY_INSTANCE_DEVICE_H

#include <vector>
#include <set>

#include <ui/Window.h>

namespace spoopy {
    class InstanceDevice {
        public:
            InstanceDevice(Window* window);
            virtual ~InstanceDevice();

            virtual void createInstance(const char* name, const int version[3]);
            virtual bool getEnabledValidationLayers() const;

            #ifdef SPOOPY_VULKAN
            virtual bool getAvailableVulkanExtensions(std::vector<const char*>& outExtensions);
            #endif
        private:
            Window* window;

            #ifdef SPOOPY_DEBUG
            const bool enableValidationLayers = false;
            #else
            const bool enableValidationLayers = true;
            #endif

            #ifdef SPOOPY_VULKAN
            virtual uint32_t getAPIVersion();

            #ifdef SPOOPY_DEBUG_MESSENGER
            virtual VKAPI_ATTR VkBool32 VKAPI_CALL CallbackDebug(VkDebugUtilsMessageSeverityFlagBitsEXT messageSeverity, VkDebugUtilsMessageTypeFlagsEXT messageTypes, 
	        const VkDebugUtilsMessengerCallbackDataEXT *pCallbackData, void *pUserData);
            #endif

            VkInstance instance = VK_NULL_HANDLE;

            const std::vector<const char*> validationLayers = {"VK_LAYER_KHRONOS_validation"};
            #endif
    };
}
#endif