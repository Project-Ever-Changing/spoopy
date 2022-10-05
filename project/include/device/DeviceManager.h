#ifndef SPOOPY_DEVICE_MANAGER_H
#define SPOOPY_DEVICE_MANAGER_H

#include <cstring>
#include <unordered_set>
#include <vector>

#include "WindowDevice.h"

namespace spoopy {
    #ifdef SPOOPY_VULKAN
    static VKAPI_ATTR VkBool32 VKAPI_CALL debugCallback(
        VkDebugUtilsMessageSeverityFlagBitsEXT messageSeverity,
        VkDebugUtilsMessageTypeFlagsEXT messageType,
        const VkDebugUtilsMessengerCallbackDataEXT *pCallbackData,
        void *pUserData) {
        std::cerr << "validation layer: " << pCallbackData->pMessage << std::endl;

        return VK_FALSE;
    }
    #endif

    class DeviceManager {
        public:
            virtual ~DeviceManager();

            const bool enableLayerSupport = true;

            #ifdef SPOOPY_VULKAN
            virtual void initAppWithVulkan(const char* name, int version[3]);
            virtual void populateDebugMessageVulkan(VkDebugUtilsMessengerCreateInfoEXT &info);
            virtual void hasRequiredInstanceExtensionsVulkan();
            virtual bool checkLayerSupportForVulkan();
            virtual std::vector<const char*> getRequiredExtensions();
            #endif
        private:
            #ifdef SPOOPY_VULKAN
            VkInstance instance;
            const std::vector<const char*> validationLayers = {"VK_LAYER_KHRONOS_validation"};
            #endif
    };
}
#endif