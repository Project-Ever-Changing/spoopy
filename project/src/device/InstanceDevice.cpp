#include <device/InstanceDevice.h>
namespace spoopy {
    InstanceDevice::InstanceDevice(Window* window) {
        this -> window = window;
    }

    void InstanceDevice::createInstance(const char* name, const int version[3]) {
        #ifdef SPOOPY_VULKAN
        VkApplicationInfo appInfo = {};
        appInfo.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
        appInfo.pApplicationName = name;
        appInfo.applicationVersion = VK_MAKE_VERSION(version[0], version[1], version[2]);
        appInfo.pEngineName = "Spoopy Engine";
        appInfo.engineVersion = VK_MAKE_VERSION(1, 0, 0);
        appInfo.apiVersion = getAPIVersion();

        if(enableValidationLayers) {
            throw "Validation layers requested, but not available!\n";
        }


        #endif
    }

    bool InstanceDevice::getEnabledValidationLayers() const {
        return enableValidationLayers;
    }

    InstanceDevice::~InstanceDevice() {

    }

    #ifdef SPOOPY_VULKAN
    bool InstanceDevice::getAvailableVulkanExtensions(std::vector<std::string>& outExtensions) {
        uint32_t ext_count = 0;

        if(window == nullptr) {
            throw "Unable to find window.";
        }

        if(window -> sdlWindow == nullptr) {
            throw "Unable to find SDL window.";
        }

        if(!SDL_Vulkan_GetInstanceExtensions(window -> sdlWindow, &ext_count, nullptr)) {
            std::cout << "Unable to query the number of Vulkan instance extensions\n";
            return false;
        }

        std::vector<const char*> ext_names(ext_count);
        if (!SDL_Vulkan_GetInstanceExtensions(window -> sdlWindow, &ext_count, ext_names.data())) {
            std::cout << "Unable to query the number of Vulkan instance extension names\n";
            return false;
        }

        for (uint32_t i = 0; i < ext_count; i++) {
            std::cout << i << ": " << ext_names[i] << "\n";
            outExtensions.emplace_back(ext_names[i]);
        }

        outExtensions.emplace_back(VK_EXT_DEBUG_REPORT_EXTENSION_NAME);
        return true;
    }

    uint32_t InstanceDevice::getAPIVersion() {
        #if defined(VK_VERSION_1_1)
        uint32_t api_version = 0;

        if(vkEnumerateInstanceVersion(&api_version) == VK_SUCCESS) {
            return api_version;
        }
        #endif

        return VK_MAKE_VERSION(1, 0, 57);
    }
    #endif
}