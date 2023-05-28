#include <helpers/SpoopyHelpers.h>

#include "Devices.h"

namespace lime {
    const std::vector<const char*> Devices::Extensions = {VK_KHR_SWAPCHAIN_EXTENSION_NAME};

    #if VK_HEADER_VERSION > 101
        const std::vector<const char*> Devices::ValidationLayers = {"VK_LAYER_KHRONOS_validation"};
    #else
        const std::vector<const char*> Devices::ValidationLayers = {"VK_LAYER_LUNARG_standard_validation"};
    #endif

    #ifdef SPOOPY_DEBUG_MESSENGER
        VKAPI_ATTR VkBool32 VKAPI_CALL Devices::DebugCallback(VkDebugUtilsMessageSeverityFlagBitsEXT messageSeverity, VkDebugUtilsMessageTypeFlagsEXT messageType,
            const VkDebugUtilsMessengerCallbackDataEXT *pCallbackData, void *pUserData) {
                if(messageSeverity & VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT) {
                    SPOOPY_LOG_WARN(pCallbackData->pMessage);
                }else if(messageSeverity &  VK_DEBUG_UTILS_MESSAGE_SEVERITY_INFO_BIT_EXT) {
                    SPOOPY_LOG_INFO(pCallbackData -> pMessage);
                }else {
                    SPOOPY_LOG_ERROR(pCallbackData->pMessage);
                }
        }
    #else
        VKAPI_ATTR VkBool32 VKAPI_CALL Devices::DebugCallback(VkDebugReportFlagsEXT flags, VkDebugReportObjectTypeEXT objectType, uint64_t object, size_t location, int32_t messageCode,
            const char *pLayerPrefix, const char *pMessage, void *pUserData) {
                if(flags & VK_DEBUG_REPORT_WARNING_BIT_EXT) {
                    SPOOPY_LOG_WARN(pMessage);
                }else if(flags & VK_DEBUG_REPORT_INFORMATION_BIT_EXT) {
                    SPOOPY_LOG_INFO(pMessage);
                }else {
                    SPOOPY_LOG_ERROR(pMessage);
                }

                return VK_FALSE;
        }
    #endif
}