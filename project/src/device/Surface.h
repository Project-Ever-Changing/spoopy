#pragma once

#ifdef SPOOPY_VOLK
#include <volk.h>
#endif

#ifdef SPOOPY_SDL

#include <SDL.h>
#include <SDL_vulkan.h>

#endif

namespace lime {
    class Instance;
    class LogicalDevice;
    class PhysicalDevice;

    class Surface {
        public:
            Surface(const Instance &instance, const PhysicalDevice &physicalDevice, const LogicalDevice &logicalDevice, SDL_Window* window);
            ~Surface();

            operator const VkSurfaceKHR &() const { return surface; }

            const VkSurfaceKHR &GetSurface() const { return surface; }
            const VkSurfaceCapabilitiesKHR &GetCapabilities() const { return capabilities; }
            const VkSurfaceFormatKHR &GetFormat() const { return format; }
        private:
            void CreateWindowSurface(SDL_Window* window, VkInstance instance, VkSurfaceKHR* surface);

            const Instance &instance;
            const PhysicalDevice &physicalDevice;
            const LogicalDevice &logicalDevice;

            SDL_Window* window;

            VkSurfaceKHR surface = VK_NULL_HANDLE;
            VkSurfaceCapabilitiesKHR capabilities = {};
            VkSurfaceFormatKHR format = {};
    };
}