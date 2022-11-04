#include <iostream>

#include <ui/Window.h>

namespace spoopy {
    #ifdef SPOOPY_VULKAN
    void Window::createWindowSurfaceVulkan(VkInstance instance, VkSurfaceKHR* surface) const {
        #ifdef SPOOPY_SDL
        if(!SDL_Vulkan_CreateSurface(sdlWindow, instance, surface)) {
            throw std::runtime_error("Failed to create Window Surface for Vulkan API!");
        }
        #endif
    }

    uint32_t Window::getExtensionCount() const {
        uint32_t count = 0;

        #ifdef SPOOPY_SDL
        if(sdlWindow == nullptr) {
            throw "Unable to find SDL window.";
        }

        if(!SDL_Vulkan_GetInstanceExtensions(sdlWindow, &count, nullptr)) {
            std::cout << "Unable to query the number of Vulkan instance extensions\n";
            foundInstanceExtensions = false;
        }else {
            foundInstanceExtensions = true;
        }
        #endif

        return count;
    }

    std::vector<const char*> Window::getInstanceExtensions(uint32_t extensionCount) const {
        std::vector<const char*> names(extensionCount);

        #ifdef SPOOPY_SDL
        if (!SDL_Vulkan_GetInstanceExtensions(sdlWindow, &extensionCount, names.data())) {
            std::cout << "Unable to query the number of Vulkan instance extension names\n";
            foundInstanceExtensions = false;
        }else {
            foundInstanceExtensions = true;
        }
        #endif

        return names;
    }

    const char* Window::getWindowTitle() const {

        /*
        * In a scenario that I would need to tell the application to use
        * GLFW in a certain case, this would be a really simple implementation.
        */
        #ifdef SPOOPY_SDL
        if(sdlWindow != nullptr) {
            return SDL_GetWindowTitle(sdlWindow);
        }
        #endif

        return nullptr; //aka. 0
    }

    Window::~Window() {
        #ifdef SPOOPY_SDL
        if(sdlWindow != nullptr) {
			SDL_DestroyWindow(sdlWindow);
			sdlWindow = nullptr;
		}
        #endif
    }
    #endif
}