#include "Surface.h"
#include "Instance.h"
#include "LogicalDevice.h"
#include "PhysicalDevice.h"

namespace lime { namespace spoopy {
    Surface::Surface(const Instance &instance, const PhysicalDevice &physicalDevice, LogicalDevice &logicalDevice, SDL_Window* window):
    instance(instance),
    physicalDevice(physicalDevice),
    logicalDevice(logicalDevice),
    window(window) {
        CreateSurface();
    }

    Surface::~Surface() {
        DestroySurface();
        window = nullptr;
    }

    void Surface::CreateWindowSurface(SDL_Window* window, VkInstance instance, VkSurfaceKHR* surface) {
        #if SPOOPY_SDL
            if(!SDL_Vulkan_CreateSurface(window, instance, surface)) {
                printf("Failed to create window surface, SDL_Error: %s\n", SDL_GetError());
            }
        #endif
    }

    void Surface::CreateSurface() {
        CreateWindowSurface(window, instance, &surface);
        checkVulkan(vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice, surface, &capabilities));

        uint32_t surfaceFormatCount = 0;
        checkVulkan(vkGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice, surface, &surfaceFormatCount, nullptr));
        std::vector<VkSurfaceFormatKHR> surfaceFormats(surfaceFormatCount);
        checkVulkan(vkGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice, surface, &surfaceFormatCount, surfaceFormats.data()));

        if(surfaceFormatCount == 1 && surfaceFormats[0].format == VK_FORMAT_UNDEFINED) {
            format.format = VK_FORMAT_B8G8R8A8_UNORM;
            format.colorSpace = surfaceFormats[0].colorSpace;
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
    }

    void Surface::DestroySurface() {
        vkDestroySurfaceKHR(instance, surface, nullptr);

        surface = VK_NULL_HANDLE;
        capabilities = {};
        format = {};
    }
}}