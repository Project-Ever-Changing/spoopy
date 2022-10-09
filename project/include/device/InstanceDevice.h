#ifndef SPOOPY_INSTANCE_DEVICE_H
#define SPOOPY_INSTANCE_DEVICE_H

#include <vector>

#include <ui/Window.h>

namespace spoopy {
    class InstanceDevice {
        public:
            InstanceDevice(Window* window);
            virtual ~InstanceDevice();

            virtual void createInstance(const char* name, const int version[3]);
            virtual bool getEnabledValidationLayers() const;

            #ifdef SPOOPY_VULKAN
            virtual bool getAvailableVulkanExtensions(std::vector<std::string>& outExtensions);
            #endif
        private:
            Window* window;

            #ifdef SPOOPY_DEBUG
            const bool enableValidationLayers = false;
            #else
            const bool enableValidationLayers = true;
            #endif

            #ifdef SPOOPY_VULKAN
            uint32_t getAPIVersion(); 

            const std::vector<const char*> validationLayers = {"VK_LAYER_KHRONOS_validation"};
            #endif
    };
}
#endif