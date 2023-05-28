#include "LogicalDevice.h"
#include "PhysicalDevice.h"
#include "Instance.h"

namespace lime {
    LogicalDevice::LogicalDevice(const Instance &instance, const PhysicalDevice &physicalDevice)
        : instance(instance), physicalDevice(physicalDevice) {
        CreateQueueIndices();
        CreateLogicalDevice();
    }

    LogicalDevice::~LogicalDevice() {
        checkVulkan(vkDeviceWaitIdle(logicalDevice));
        vkDestroyDevice(logicalDevice, nullptr);
    }

    void LogicalDevice::CreateQueueIndices() {
        uint32_t deviceQueueFamilyPropertyCount;
        vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice, &deviceQueueFamilyPropertyCount, nullptr);
        std::vector<VkQueueFamilyProperties> deviceQueueFamilyProperties(deviceQueueFamilyPropertyCount);
        vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice, &deviceQueueFamilyPropertyCount, deviceQueueFamilyProperties.data());

        std::unique_ptr<uint32_t> graphicsFamily, presentFamily, computeFamily, transferFamily;

        for(uint32_t i=0; i<deviceQueueFamilyPropertyCount; i++) {
            if (deviceQueueFamilyProperties[i].queueFlags & VK_QUEUE_GRAPHICS_BIT) {
                graphicsFamily.reset(new uint32_t(i));
                this->graphicsFamily = i;
                supportedQueues |= VK_QUEUE_GRAPHICS_BIT;
            }

            /*
            VkBool32 presentSupport = false;
            vkGetPhysicalDeviceSurfaceSupportKHR(physicalDevice, i, instance.GetSurface(), &presentSupport);
            */

            if(deviceQueueFamilyProperties[i].queueCount > 0) {
                presentFamily.reset(new uint32_t(i));
                this->presentFamily = i;
            }

            if(deviceQueueFamilyProperties[i].queueFlags & VK_QUEUE_COMPUTE_BIT) {
                computeFamily.reset(new uint32_t(i));
                this->computeFamily = i;
                supportedQueues |= VK_QUEUE_COMPUTE_BIT;
            }

            if(deviceQueueFamilyProperties[i].queueFlags & VK_QUEUE_TRANSFER_BIT) {
                transferFamily.reset(new uint32_t(i));
                this->transferFamily = i;
                supportedQueues |= VK_QUEUE_TRANSFER_BIT;
            }

            if(graphicsFamily && presentFamily && computeFamily && transferFamily) {
                break;
            }
        }

        if(!graphicsFamily) {
            SPOOPY_LOG_ERROR("Failed to find graphics family!");
        }
    }

    void LogicalDevice::CreateLogicalDevice() {
        std::vector<VkDeviceQueueCreateInfo> queueCreateInfos;
        float queuePriority = 1.0f;

        if(supportedQueues & VK_QUEUE_GRAPHICS_BIT) {
            VkDeviceQueueCreateInfo graphicsQueueCreateInfo = {};
            graphicsQueueCreateInfo.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
            graphicsQueueCreateInfo.queueFamilyIndex = graphicsFamily;
            graphicsQueueCreateInfo.queueCount = 1;
            graphicsQueueCreateInfo.pQueuePriorities = &queuePriority;
            queueCreateInfos.emplace_back(graphicsQueueCreateInfo);
        } else {
            graphicsFamily = 0;
        }

        if(supportedQueues & VK_QUEUE_COMPUTE_BIT && computeFamily != graphicsFamily) {
            VkDeviceQueueCreateInfo computeQueueCreateInfo = {};
            computeQueueCreateInfo.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
            computeQueueCreateInfo.queueFamilyIndex = computeFamily;
            computeQueueCreateInfo.queueCount = 1;
            computeQueueCreateInfo.pQueuePriorities = &queuePriority;
            queueCreateInfos.emplace_back(computeQueueCreateInfo);
        }else {
            computeFamily = graphicsFamily;
        }

        if(supportedQueues & VK_QUEUE_TRANSFER_BIT && transferFamily != graphicsFamily && transferFamily != computeFamily) {
            VkDeviceQueueCreateInfo transferQueueCreateInfo = {};
            transferQueueCreateInfo.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
            transferQueueCreateInfo.queueFamilyIndex = transferFamily;
            transferQueueCreateInfo.queueCount = 1;
            transferQueueCreateInfo.pQueuePriorities = &queuePriority;
            queueCreateInfos.emplace_back(transferQueueCreateInfo);
        }else {
            transferFamily = graphicsFamily;
        }

        auto physicalDeviceFeatures = physicalDevice.GetFeatures();

        VkPhysicalDeviceFeatures enabledFeatures = {
            .sampleRateShading = physicalDeviceFeatures.sampleRateShading,
            .samplerAnisotropy = physicalDeviceFeatures.samplerAnisotropy,
            .fullDrawIndexUint32 = physicalDeviceFeatures.fullDrawIndexUint32,
            .vertexPipelineStoresAndAtomics = physicalDeviceFeatures.vertexPipelineStoresAndAtomics,
            .fragmentStoresAndAtomics = physicalDeviceFeatures.fragmentStoresAndAtomics,
            .shaderImageGatherExtended = physicalDeviceFeatures.shaderImageGatherExtended,
            .shaderStorageImageExtendedFormats = physicalDeviceFeatures.shaderStorageImageExtendedFormats,
            .shaderStorageImageWriteWithoutFormat = physicalDeviceFeatures.shaderStorageImageWriteWithoutFormat,
            .shaderClipDistance = physicalDeviceFeatures.shaderClipDistance,
            .shaderCullDistance = physicalDeviceFeatures.shaderCullDistance,
            .shaderResourceMinLod = physicalDeviceFeatures.shaderResourceMinLod,
            .geometryShader = physicalDeviceFeatures.geometryShader,
            .tessellationShader = physicalDeviceFeatures.tessellationShader,
            .multiViewport = physicalDeviceFeatures.multiViewport,
        };

        if(physicalDeviceFeatures.fillModeNonSolid) {
            enabledFeatures.fillModeNonSolid = VK_TRUE;

            if(physicalDeviceFeatures.wideLines) {
                enabledFeatures.wideLines = VK_TRUE;
            }
        }else {
            SPOOPY_LOG_WARN("Wireframe pipelines are not supported on this device!");
        }

        if(physicalDeviceFeatures.textureCompressionBC) {
            enabledFeatures.textureCompressionBC = VK_TRUE;
        }else if (physicalDeviceFeatures.textureCompressionASTC_LDR) {
            enabledFeatures.textureCompressionASTC_LDR = VK_TRUE;
        }else if (physicalDeviceFeatures.textureCompressionETC2) {
            enabledFeatures.textureCompressionETC2 = VK_TRUE;
        }

        VkDeviceCreateInfo deviceCreateInfo = {};
        deviceCreateInfo.sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
        deviceCreateInfo.queueCreateInfoCount = static_cast<uint32_t>(queueCreateInfos.size());
        deviceCreateInfo.pQueueCreateInfos = queueCreateInfos.data();

        if(instance.GetEnableValidationLayers()) {
            deviceCreateInfo.enabledLayerCount = static_cast<uint32_t>(Devices::ValidationLayers.size());
            deviceCreateInfo.ppEnabledLayerNames = Devices::ValidationLayers.data();
        }

        deviceCreateInfo.enabledExtensionCount = static_cast<uint32_t>(Devices::Extensions.size());
        deviceCreateInfo.ppEnabledExtensionNames = Devices::Extensions.data();
        deviceCreateInfo.pEnabledFeatures = &enabledFeatures;

        checkVulkan(vkCreateDevice(physicalDevice, &deviceCreateInfo, nullptr, &logicalDevice));
        volkLoadDevice(logicalDevice);

        vkGetDeviceQueue(logicalDevice, graphicsFamily, 0, &graphicsQueue);
        vkGetDeviceQueue(logicalDevice, presentFamily, 0, &presentQueue);
        vkGetDeviceQueue(logicalDevice, computeFamily, 0, &computeQueue);
        vkGetDeviceQueue(logicalDevice, transferFamily, 0, &transferQueue);
    }
}