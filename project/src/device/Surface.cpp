#include "Surface.h"
#include "Instance.h"
#include "LogicalDevice.h"
#include "PhysicalDevice.h"

namespace lime { namespace spoopy {
    Surface::Surface(const Instance &instance, const PhysicalDevice &physicalDevice, const LogicalDevice &logicalDevice, SDL_Window* window):
    instance(instance),
    physicalDevice(physicalDevice),
    logicalDevice(logicalDevice),
    window(window) {
        CreateWindowSurface(window, instance, &surface);
        checkVulkan(vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice, surface, &capabilities));

        uint32_t surfaceFormatCount = 0;
        vkGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice, surface, &surfaceFormatCount, nullptr);
        std::vector<VkSurfaceFormatKHR> surfaceFormats(surfaceFormatCount);
        vkGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice, surface, &surfaceFormatCount, surfaceFormats.data());

        if(surfaceFormatCount == 1 && surfaceFormats[0].format == VK_FORMAT_UNDEFINED) {
            format.format = VK_FORMAT_B8G8R8A8_UNORM;
            format.colorSpace = surfaceFormats[0].colorSpace;
        }else {
            bool found_B8G8R8A8_UNORM = false;

            for(auto &surfaceFormat: surfaceFormats) {
                if(surfaceFormat.format == VK_FORMAT_B8G8R8A8_UNORM) {
                    format.format = surfaceFormat.format;
                    format.colorSpace = surfaceFormat.colorSpace;
                    found_B8G8R8A8_UNORM = true;
                    break;
                }
            }

            if(!found_B8G8R8A8_UNORM) {
                format.format = surfaceFormats[0].format;
                format.colorSpace = surfaceFormats[0].colorSpace;
            }

            VkBool32 presentSupport;
            vkGetPhysicalDeviceSurfaceSupportKHR(physicalDevice, logicalDevice.GetPresentFamily(), surface, &presentSupport);

            if(!presentSupport) {
                throw std::runtime_error("Present queue family does not have presentation support!");
            }
        }
    }

    Surface::~Surface() {
        vkDestroySurfaceKHR(instance, surface, nullptr);
    }

    void Surface::CreateWindowSurface(SDL_Window* window, VkInstance instance, VkSurfaceKHR* surface) {
        #if SPOOPY_SDL
            if(!SDL_Vulkan_CreateSurface(window, instance, surface)) {
                printf("%s", "Failed to create window surface, SDL_Error: %s", SDL_GetError());
            }
        #endif
    }
}}