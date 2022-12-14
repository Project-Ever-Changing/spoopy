#ifndef SPOOPY_UI_WINDOW_H
#define SPOOPY_UI_WINDOW_H

#include <vector>

#ifdef SPOOPY_SDL
#include <sdl/SpoopySDLWindow.h>
#endif

namespace spoopy {
    class SpoopyWindow: public SpoopySDLWindow {
        public:
            SpoopyWindow(int width, int height, int flags, const char* title): SpoopySDLWindow(width, height, flags, title) {};

            virtual const char* getWindowTitle() const;

            #ifdef SPOOPY_VULKAN
            virtual void createWindowSurfaceVulkan(VkInstance instance, VkSurfaceKHR* surface) const;
            virtual uint32_t getExtensionCount() const;
            virtual std::vector<const char*> getInstanceExtensions(uint32_t extensionCount) const;

            virtual bool foundedInstanceExtensions() const {return foundInstanceExtensions;}
            #endif
        private:
            #ifdef SPOOPY_SDL

            /*
            * Not the best setup for this.
            */
            mutable bool foundInstanceExtensions = false;
            #endif
    };
}
#endif