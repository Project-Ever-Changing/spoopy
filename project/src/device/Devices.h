#pragma once

#ifdef SPOOPY_VOLK
#include <volk.h>
#endif

#include <vector>

namespace lime {
    struct Devices {
        #ifdef SPOOPY_DEBUG_MESSENGER
        static VKAPI_ATTR VkBool32 VKAPI_CALL DebugCallback(
            VkDebugUtilsMessageSeverityFlagBitsEXT messageSeverity,
            VkDebugUtilsMessageTypeFlagsEXT messageType,
            const VkDebugUtilsMessengerCallbackDataEXT* pCallbackData,
            void* pUserData);
        #else
        static VKAPI_ATTR VkBool32 VKAPI_CALL DebugCallback(
            VkDebugReportFlagsEXT flags,
            VkDebugReportObjectTypeEXT objType,
            uint64_t obj,
            size_t location,
            int32_t code,
            const char* layerPrefix,
            const char* msg,
            void* userData);
        #endif

        static const std::vector<const char*> Extensions;
        static const std::vector<const char*> ValidationLayers;
    };
}