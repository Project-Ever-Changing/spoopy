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

        static const std::vector<const char*> ValidationLayers;

        private:
            bool CheckValidationLayerSupport() const;
            std::vector<const char*> GetExtensions() const;

            void CreateInstance();
            void CreateDebugMessenger();

            SDL_Window* m_window;

            bool enableValidationLayers = false;
            bool enableDebugMode = false;

            VkInstance instance = VK_NULL_HANDLE;

            #if SPOOPY_DEBUG_MESSENGER
            VkDebugUtilsMessengerEXT debugMessenger = VK_NULL_HANDLE;
            #else
            VkDebugReportCallbackEXT debugMessenger = VK_NULL_HANDLE;
            #endif
    };
}}