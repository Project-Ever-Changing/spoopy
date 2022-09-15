#include <device/WindowDevice.h>

namespace spoopy {
    #ifdef SPOOPY_VULKAN
    void WindowDevice::createWindowSurfaceVulkan(VkInstance instance, VkSurfaceKHR* surface) {
        //if(!SDL_Vulkan_CreateSurface(sdlWindow, instance, surface)) {
        //    throw std::runtime_error("Failed to create Window Surface for Vulkan API!");
        //}
    }

    WindowDevice::~WindowDevice() {
        
    }
    #endif
}