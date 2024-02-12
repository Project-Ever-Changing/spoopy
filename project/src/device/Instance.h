#pragma once

#include "../helpers/VulkanAddons.h"
#include "../helpers/SpoopyHelpersVulkan.h"

#include <core/Log.h>

#include <vector>

namespace lime { namespace spoopy {
    class Instance {
        public:
            Instance(SDL_Window* window);
            ~Instance();

            operator const VkInstance &() const { return instance; }

            bool GetEnableValidationLayers() const { return enableValidationLayers; }
            const VkInstance &GetInstance() const { return instance; }

            static void AddValidationLayers(std::vector<VkLayerProperties> &availableLayers
            , std::vector<const char*> &validationLayers);
            static bool CheckLayerSupport(const std::vector<VkLayerProperties> &layers, const char* layerName);

        private:
            bool CheckValidationLayerSupport();
            void GetExtensions(std::vector<const char*> &extensions, uint32_t &size) const;

            void CreateInstance();
            void CreateDebugMessenger();

            SDL_Window* m_window;

            bool enableValidationLayers = false;
            bool enableDebugMode = false;

            VkInstance instance = VK_NULL_HANDLE;

            std::vector<const char*> validationLayers = {};
            std::vector<VkLayerProperties> availableLayers = {};

            #if SPOOPY_DEBUG_MESSENGER
            VkDebugUtilsMessengerEXT debugMessenger = VK_NULL_HANDLE;
            #else
            VkDebugReportCallbackEXT debugMessenger = VK_NULL_HANDLE;
            #endif
    };
}}
