#pragma once

#include <ui/SpoopyWindowSurface.h>

#ifdef SPOOPY_VULKAN

namespace lime {
    class SpoopyWindowVulkan: public SpoopyWindowSurface {
        public:
            SpoopyWindowVulkan(const SDLWindow &m_window);

            virtual void createWindowSurfaceVulkan(VkInstance instance, VkSurfaceKHR* surface) const;
            virtual bool foundedInstanceExtensions() const {return foundInstanceExtensions;}

            virtual void render();
            virtual void clear();

            virtual void useProgram(value __pipeline);
            virtual void setVertexBuffer(value __buffer, int __offset, int __atIndex) = 0;
            virtual void cullFace(int cullMode);

            virtual const SDLWindow& getWindow() const;
        private:
            const SDLWindow &m_window;

            /*
            * Not the best setup for this.
            */
            mutable bool foundInstanceExtensions = false;
    };
}

#endif