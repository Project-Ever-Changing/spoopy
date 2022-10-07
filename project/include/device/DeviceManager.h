#ifndef SPOOPY_DEVICE_MANAGER_H
#define SPOOPY_DEVICE_MANAGER_H

#include <cstring>
#include <set>
#include <unordered_set>
#include <vector>

#include "WindowDevice.h"
#include "../structs/QueneFamilyIndices.hpp"

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
            virtual void initAppWithVulkan(const char* name, const int version[3]);
            virtual void setupDebugMessenger();
            virtual void populateDebugMessageVulkan(VkDebugUtilsMessengerCreateInfoEXT &info);
            virtual void hasRequiredInstanceExtensionsVulkan();
            virtual void choosePhysicalDeviceVulkan();
            virtual void createLogicalDeviceVulkan();
            virtual bool isSuitableDevice(VkPhysicalDevice device);
            virtual bool checkDeviceExtensionSupportVulkan(VkPhysicalDevice device);
            virtual bool checkLayerSupportForVulkan();
            virtual VkInstance getInstance();
            virtual VkSurfaceKHR* getSurface();
            virtual QueueFamilyIndices findQueueFamilies(VkPhysicalDevice device);
            virtual std::vector<const char*> getRequiredExtensions();

            virtual VkResult CreateDebugUtilsMessengerVulkan(VkInstance instance,
                const VkDebugUtilsMessengerCreateInfoEXT *pCreateInfo,
                const VkAllocationCallbacks *pAllocator,
                VkDebugUtilsMessengerEXT *pDebugMessenger);
            #endif
        private:
            #ifdef SPOOPY_VULKAN
            VkInstance instance;
            VkDebugUtilsMessengerEXT debugMessenger;
            VkPhysicalDevice physicalDevice = VK_NULL_HANDLE;
            VkPhysicalDeviceProperties properties;

            VkSurfaceKHR surface_;
            VkDevice device_;
            VkQueue graphicsQueue_;
            VkQueue presentQueue_;

            const std::vector<const char*> validationLayers = {"VK_LAYER_KHRONOS_validation"};
            const std::vector<const char*> deviceExtensions = {VK_KHR_SWAPCHAIN_EXTENSION_NAME};
            #endif
    };
}
#endif