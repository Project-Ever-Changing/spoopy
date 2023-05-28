#include "PhysicalDevice.h"
#include "Instance.h"
#include "Devices.h"

namespace lime {
    PhysicalDevice::PhysicalDevice(const Instance &instance): instance(instance) {
        uint32_t physicalDeviceCount;
        vkEnumeratePhysicalDevices(instance, &physicalDeviceCount, nullptr);
        std::vector<VkPhysicalDevice> physicalDevices(physicalDeviceCount);
        vkEnumeratePhysicalDevices(instance, &physicalDeviceCount, physicalDevices.data());

        physicalDevice = BestPhysicalDevice(physicalDevices);

        if(!physicalDevice) {
            SPOOPY_LOG_ERROR("Couldn't find a GPU suitable for Vulkan!");
        }

        vkGetPhysicalDeviceProperties(physicalDevice, &properties);
        vkGetPhysicalDeviceFeatures(physicalDevice, &features);
        vkGetPhysicalDeviceMemoryProperties(physicalDevice, &memoryProperties);
        msaaSamples = GetMaxUsableSampleCount(physicalDevice);
    }

    VkPhysicalDevice PhysicalDevice::BestPhysicalDevice(const std::vector<VkPhysicalDevice> &devices) {
        std::multimap<uint32_t, VkPhysicalDevice> rankedDevices;
        auto last = rankedDevices.end();

        for(const auto &device : devices) {
            last = rankedDevices.insert(last, {ScorePhysicalDevice(device), device});
        }

        if(rankedDevices.rbegin()->first > 0) {
            return rankedDevices.rbegin()->second;
        }

        return nullptr;
    }

    uint32_t PhysicalDevice::ScorePhysicalDevice(const VkPhysicalDevice &device) {
        uint32_t score = 0;

        uint32_t count;
        vkEnumerateDeviceExtensionProperties(device, nullptr, &count, nullptr);
        std::vector<VkExtensionProperties> extensionProperties(count);
        vkEnumerateDeviceExtensionProperties(device, nullptr, &count, extensionProperties.data());

        for(const char* extension: Devices::Extensions) {
            bool found = false;

            for(const auto& extensionProperty: extensionProperties) {
                if(strcmp(extension, extensionProperty.extensionName) == 0) {
                    found = true;
                    break;
                }
            }

            if(!found) {
                return 0;
            }
        }

        VkPhysicalDeviceProperties physicalDeviceProperties;
        VkPhysicalDeviceFeatures physicalDeviceFeatures;
        vkGetPhysicalDeviceProperties(device, &physicalDeviceProperties);
        vkGetPhysicalDeviceFeatures(device, &physicalDeviceFeatures);

        if (physicalDeviceProperties.deviceType == VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU) {
            score += 1000;
        }

        score += physicalDeviceProperties.limits.maxImageDimension2D;
        return score;
    }
}