#include <device/PhysicalDevice.h>
#include <device/InstanceDevice.h>
#include <device/Devices.h>

#include <iomanip>

namespace lime {
    PhysicalDevice::PhysicalDevice(const InstanceDevice &instance) {
        #ifdef SPOOPY_VULKAN
        uint32_t physicalCount;

        vkEnumeratePhysicalDevices(instance.getInstance(), &physicalCount, nullptr);
        std::vector<VkPhysicalDevice> physicalDevices(physicalCount);
        vkEnumeratePhysicalDevices(instance.getInstance(), &physicalCount, physicalDevices.data());

        physicalDevice = getSuitablePhysical(physicalDevices);

        if (!physicalDevice) {
		    throw std::runtime_error("Vulkan runtime error!\nFailed to find a suitable GPU!");
        }

        vkGetPhysicalDeviceProperties(physicalDevice, &properties);
        vkGetPhysicalDeviceFeatures(physicalDevice, &features);
        vkGetPhysicalDeviceMemoryProperties(physicalDevice, &memoryProperties);

        sampleCountBits = getMaxUsableSampleCount(physicalDevice);
        #endif
    }

    #ifdef SPOOPY_VULKAN
    VkPhysicalDevice PhysicalDevice::getSuitablePhysical(const std::vector<VkPhysicalDevice> &physicalDevices) {
        std::multimap<uint32_t, VkPhysicalDevice> candidates;
        auto lastRow = candidates.end();

        for(const auto &device: physicalDevices) {
            lastRow = candidates.insert(lastRow, {scoreDeviceSuitability(device), device});
        }

        if(candidates.rbegin()->first > 0) {
            return candidates.rbegin()->second;
        }else {
            throw std::runtime_error("Vulkan runtime error, failed to find a suitable GPU.");
        }

        return nullptr;
    }

    uint32_t PhysicalDevice::scoreDeviceSuitability(VkPhysicalDevice device) {
        uint32_t extensionPropertyCount;
        uint32_t score = 0;

        vkEnumerateDeviceExtensionProperties(device, nullptr, &extensionPropertyCount, nullptr);
        std::vector<VkExtensionProperties> extensionProperties(extensionPropertyCount);
        vkEnumerateDeviceExtensionProperties(device, nullptr, &extensionPropertyCount, extensionProperties.data());

        for(const char* extension: Devices::Extensions) {
            bool extensionFound = false;

            for(const auto &extensionProperty: extensionProperties) {
                if (strcmp(extension, extensionProperty.extensionName) == 0) {
                    extensionFound = true;
                    break;
                }
            }

            if (!extensionFound) {
			    return 0;
            }
        }

        VkPhysicalDeviceProperties deviceProperties;
        VkPhysicalDeviceFeatures deviceFeatures;
        vkGetPhysicalDeviceProperties(device, &deviceProperties);
        vkGetPhysicalDeviceFeatures(device, &deviceFeatures);

        if(deviceProperties.deviceType == VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU) {
            score += 1000;
        }

        score += deviceProperties.limits.maxImageDimension2D;

        if (!deviceFeatures.geometryShader) {
            return 0;
        }

        return score;
    }
    #endif
}