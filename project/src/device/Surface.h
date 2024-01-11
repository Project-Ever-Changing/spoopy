#pragma once

#include "../helpers/SpoopyHelpersVulkan.h"

namespace lime { namespace spoopy {
    class Instance;
    class LogicalDevice;
    class PhysicalDevice;

    class Surface {
        public:
            Surface(const Instance &instance, PhysicalDevice &physicalDevice, LogicalDevice &logicalDevice, SDL_Window* window);
            ~Surface();

            operator const VkSurfaceKHR &() const { return surface; }

            const VkSurfaceKHR &GetSurface() const { return surface; }
            const VkSurfaceCapabilitiesKHR &GetCapabilities() const { return capabilities; }
            const VkSurfaceFormatKHR &GetFormat() const { return format; }

            void CreateSurface();
            void DestroySurface();
        private:
            void CreateWindowSurface(SDL_Window* window, VkInstance instance, VkSurfaceKHR* surface);

            const Instance &instance;
            LogicalDevice &logicalDevice;
            PhysicalDevice &physicalDevice;

            SDL_Window* window;

            VkSurfaceKHR surface;
            VkSurfaceCapabilitiesKHR capabilities;
            VkSurfaceFormatKHR format;
    };
}}