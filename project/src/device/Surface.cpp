#include "Surface.h"
#include "Instance.h"
#include "LogicalDevice.h"
#include "PhysicalDevice.h"

#include <spoopy_assert.h>

#if defined(HX_MACOS)

#include "MacSurfaceCreate.h"

#endif

#if defined(SPOOPY_SDL) && defined(HX_MACOS)

#define VK_CREATE_SURFACE spoopy_mac::MacCreateSurface

#elif defined(SPOOPY_SDL)

#define VK_CREATE_SURFACE VkCreateSurface

#endif

namespace lime { namespace spoopy {

    // Basic helper function to convert SDL_PixelFormatEnum to VkFormat
    VkFormat SDLFormatToVkFormat(const Uint32 &format) {
        switch(format) {
            case SDL_PIXELFORMAT_ARGB8888: return VK_FORMAT_A2R10G10B10_UNORM_PACK32;
            case SDL_PIXELFORMAT_BGRA8888: return VK_FORMAT_B8G8R8A8_UNORM;
            case SDL_PIXELFORMAT_RGBA8888: return VK_FORMAT_R8G8B8A8_UNORM;
            default: return VK_FORMAT_UNDEFINED;
        }
    }

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

    void Surface::CreateSurface() {
        SP_ASSERT(window && instance != VK_NULL_HANDLE
        && physicalDevice.GetPhysicalDevice() != VK_NULL_HANDLE);

        if(!VK_CREATE_SURFACE(window, instance, &surface)) {
            printf("Failed to create window surface, SDL_Error: %s\n", SDL_GetError());
        }

        uint32_t surfaceFormatCount;
        vkGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice.GetPhysicalDevice(), surface, &surfaceFormatCount, nullptr);
        SP_ASSERT(surfaceFormatCount > 0);

        std::vector<VkSurfaceFormatKHR> surfaceFormats(surfaceFormatCount);
        vkGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice.GetPhysicalDevice(), surface, &surfaceFormatCount, surfaceFormats.data());

        Uint32 pixelFormat = SDL_GetWindowPixelFormat(window);
        VkFormat findFormat = SDLFormatToVkFormat(pixelFormat);
        bool foundFormat = false;

        for(auto &surfaceFormat: surfaceFormats) {
            if(surfaceFormat.format == findFormat) {
                format.format = surfaceFormat.format;
                format.colorSpace = surfaceFormat.colorSpace;
                foundFormat = true;

                #ifdef SPOOPY_DEBUG
                SPOOPY_LOG_INFO("Found matching surface format");
                #endif

                break;
            }
        }

        if (!foundFormat) {
            if(surfaceFormatCount == 1 && surfaceFormats[0].format == VK_FORMAT_UNDEFINED) {
                format.format = VK_FORMAT_B8G8R8A8_UNORM;
                format.colorSpace = surfaceFormats[0].colorSpace;

                #ifdef SPOOPY_DEBUG
                SPOOPY_LOG_INFO("Surface format is undefined, using VK_FORMAT_B8G8R8A8_UNORM");
                #endif
            } else {
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

#undef VK_CREATE_SURFACE