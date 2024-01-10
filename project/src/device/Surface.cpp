#include "Surface.h"
#include "Instance.h"
#include "LogicalDevice.h"
#include "PhysicalDevice.h"

#include <spoopy_assert.h>

namespace lime { namespace spoopy {
    Surface::Surface(const Instance &instance, PhysicalDevice &physicalDevice, LogicalDevice &logicalDevice, SDL_Window* window):
    instance(instance),
    physicalDevice(physicalDevice),
    logicalDevice(logicalDevice),
    window(window),
    surface(VK_NULL_HANDLE) {
        CreateSurface();
    }

    Surface::~Surface() {
        DestroySurface();
        window = nullptr;
    }

    void Surface::CreateWindowSurface(SDL_Window* window, VkInstance instance, VkSurfaceKHR* surface) {
        #ifdef SPOOPY_SDL

        if(!SDL_Vulkan_CreateSurface(window, instance, surface)) {
            printf("Failed to create window surface, SDL_Error: %s\n", SDL_GetError());
        }

        #endif
    }

    void Surface::CreateSurface() {
        SP_ASSERT(window || instance == VK_NULL_HANDLE
        || physicalDevice.GetPhysicalDevice() == VK_NULL_HANDLE);
        CreateWindowSurface(window, instance, &surface);

        uint32_t surfaceFormatCount;
        vkGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice.GetPhysicalDevice(), surface, &surfaceFormatCount, nullptr);
        SP_ASSERT(surfaceFormatCount > 0);

        std::vector<VkSurfaceFormatKHR> surfaceFormats(surfaceFormatCount);
        vkGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice.GetPhysicalDevice(), surface, &surfaceFormatCount, surfaceFormats.data());

        if(surfaceFormatCount == 1 && surfaceFormats[0].format == VK_FORMAT_UNDEFINED) {
            format.format = VK_FORMAT_B8G8R8A8_UNORM;
            format.colorSpace = surfaceFormats[0].colorSpace;

            SPOOPY_LOG_INFO("Surface format is undefined, using B8G8R8A8_UNORM");
        }else {
            bool found_B8G8R8A8_UNORM = false;

            for (auto &surfaceFormat: surfaceFormats) {
                if (surfaceFormat.format == VK_FORMAT_B8G8R8A8_UNORM) {
                    format.format = surfaceFormat.format;
                    format.colorSpace = surfaceFormat.colorSpace;
                    found_B8G8R8A8_UNORM = true;
                    break;
                }
            }

            if (!found_B8G8R8A8_UNORM) {
                format.format = surfaceFormats[0].format;
                format.colorSpace = surfaceFormats[0].colorSpace;
            }
        }

        checkVulkan(vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice.GetPhysicalDevice(), surface, &capabilities));
    }

    void Surface::DestroySurface() {
        vkDestroySurfaceKHR(instance, surface, nullptr);

        surface = VK_NULL_HANDLE;
        capabilities = {};
        format = {};
    }
}}