#include "MacSurfaceCreate.h"
#include "../helpers/VulkanAddons.h"

#include <SDL.h>
#import <Cocoa/Cocoa.h>

namespace spoopy_mac {
    bool MacCreateSurface(SDL_Window* window, VkInstance instance, VkSurfaceKHR* surface) {
        if(!window || instance == VK_NULL_HANDLE || !surface) {
            printf("%s", "Invalid arguments passed to MacCreateSurface");
            return false;
        }

        SDL_SysWMinfo windowInfo;
        SDL_VERSION(&windowInfo.version); // Initialize info structure with SDL version info

        if (!SDL_GetWindowWMInfo(window, &windowInfo)) {
            printf("Failed to get window info, SDL_Error: %s", SDL_GetError());
            return false;
        }

        // Ensure we are on macOS
        if (windowInfo.subsystem != SDL_SYSWM_COCOA) {
            printf("%s", "Window subsystem is not SDL_SYSWM_COCOA, meaning we are not on macOS!");
            return false;
        }

        NSView* nsView = windowInfo.info.cocoa.window.contentView;
        VkMacOSSurfaceCreateInfoMVK surfaceCreateInfo = {};
        surfaceCreateInfo.sType = VK_STRUCTURE_TYPE_MACOS_SURFACE_CREATE_INFO_MVK;
        surfaceCreateInfo.pView = (__bridge void*)nsView;

        lime::spoopy::FvkCreateMacOSSurfaceMVK(instance, &surfaceCreateInfo, nullptr, surface);
    }
}