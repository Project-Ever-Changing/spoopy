#include <iostream>

#include <ui/SpoopyWindow.h>

namespace spoopy {
    #ifdef SPOOPY_VULKAN
    void SpoopyWindow::createWindowSurfaceVulkan(VkInstance instance, VkSurfaceKHR* surface) const {
        #ifdef SPOOPY_SDL
        if(!SDL_Vulkan_CreateSurface(m_window, instance, surface)) {
            throw std::runtime_error("Failed to create Window Surface for Vulkan API!");
        }
        #endif
    }

    uint32_t SpoopyWindow::getExtensionCount() const {
        uint32_t count = 0;

        #ifdef SPOOPY_SDL
        if(m_window == nullptr) {
            throw "Unable to find SDL window.";
        }

        if(!SDL_Vulkan_GetInstanceExtensions(m_window, &count, nullptr)) {
            std::cout << "Unable to query the number of Vulkan instance extensions\n";
            foundInstanceExtensions = false;
        }else {
            foundInstanceExtensions = true;
        }
        #endif

        return count;
    }

    std::vector<const char*> SpoopyWindow::getInstanceExtensions(uint32_t extensionCount) const {
        std::vector<const char*> names(extensionCount);

        #ifdef SPOOPY_SDL
        if (!SDL_Vulkan_GetInstanceExtensions(m_window, &extensionCount, names.data())) {
            std::cout << "Unable to query the number of Vulkan instance extension names\n";
            foundInstanceExtensions = false;
        }else {
            foundInstanceExtensions = true;
        }
        #endif

        return names;
    }

    const char* SpoopyWindow::getWindowTitle() const {

        /*
        * In a scenario that I would need to tell the application to use
        * GLFW in a certain case, this would be a really simple implementation.
        */
        #ifdef SPOOPY_SDL
        if(m_window != nullptr) {
            return SDL_GetWindowTitle(m_window);
        }
        #endif

        return nullptr; //aka. 0
    }
    #endif
}