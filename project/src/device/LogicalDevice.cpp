#include <device/LogicalDevice.h>
#include <device/InstanceDevice.h>
#include <device/PhysicalDevice.h>

namespace spoopy {
    LogicalDevice::LogicalDevice(const InstanceDevice &instance, const PhysicalDevice &physical):
    instance(instance), physical(physical) {
        uint32_t deviceQueueFamilyPropertyCount;

        #ifdef SPOOPY_VULKAN
        vkGetPhysicalDeviceQueueFamilyProperties(physical.getPhysicalDevice(), &deviceQueueFamilyPropertyCount, nullptr);
        std::vector<VkQueueFamilyProperties> deviceQueueFamilyProperties(deviceQueueFamilyPropertyCount);
        vkGetPhysicalDeviceQueueFamilyProperties(physical.getPhysicalDevice(), &deviceQueueFamilyPropertyCount, deviceQueueFamilyProperties.data());

        queueFamily = new QueueFamilyIndices(deviceQueueFamilyProperties);
        #endif
    }

    void LogicalDevice::initDevice() {
        #ifdef SPOOPY_VULKAN
        queueFamily -> createQueueInfos();

        auto physicalDeviceFeatures = physical.getFeatures();

        if(physicalDeviceFeatures.sampleRateShading) {
		    enabledFeatures.sampleRateShading = VK_TRUE;
        }

        if(physicalDeviceFeatures.fillModeNonSolid) {
		    enabledFeatures.fillModeNonSolid = VK_TRUE;

            if (physicalDeviceFeatures.wideLines) {
			    enabledFeatures.wideLines = VK_TRUE;
            }
        }else {
            SPOOPY_LOG_WARN("GPU does not support wireframe pipelines!\n");
        }

        if(physicalDeviceFeatures.samplerAnisotropy) {
            enabledFeatures.samplerAnisotropy = VK_TRUE;
        }else {
            SPOOPY_LOG_WARN("GPU does not support sampler anisotropy!\n");
        }

        if(physicalDeviceFeatures.textureCompressionBC) {
            enabledFeatures.textureCompressionBC = VK_TRUE;
        }else if(physicalDeviceFeatures.textureCompressionASTC_LDR) {
            enabledFeatures.textureCompressionASTC_LDR = VK_TRUE;
        }else if(physicalDeviceFeatures.textureCompressionETC2) {
            enabledFeatures.textureCompressionETC2 = VK_TRUE;
        }

        if(physicalDeviceFeatures.vertexPipelineStoresAndAtomics) {
            enabledFeatures.vertexPipelineStoresAndAtomics = VK_TRUE;
        }else {
            SPOOPY_LOG_WARN("GPU does not support vertex pipeline stores and atomics!\n");
        }

        if(physicalDeviceFeatures.fragmentStoresAndAtomics) {
            enabledFeatures.fragmentStoresAndAtomics = VK_TRUE;
        }else {
            SPOOPY_LOG_WARN("GPU does not support fragment stores and atomics!\n");
        }

        if(physicalDeviceFeatures.shaderStorageImageExtendedFormats) {
            enabledFeatures.shaderStorageImageExtendedFormats = VK_TRUE;
        }else {
            SPOOPY_LOG_WARN("GPU does not support shader storage extended formats!");
        }

        if(physicalDeviceFeatures.shaderStorageImageWriteWithoutFormat) {
            enabledFeatures.shaderStorageImageWriteWithoutFormat = VK_TRUE;
        }else {
            SPOOPY_LOG_WARN("GPU does not support shader storage write without format!\n");
        }

        if(physicalDeviceFeatures.geometryShader) {
            enabledFeatures.geometryShader = VK_TRUE;
        }else {
            SPOOPY_LOG_WARN("GPU does not support geometry shaders!\n");
        }

        if(physicalDeviceFeatures.tessellationShader) {
            enabledFeatures.tessellationShader = VK_TRUE;
        }else {
            SPOOPY_LOG_WARN("GPU does not support tessellation shaders!\n");
        }

        if(physicalDeviceFeatures.multiViewport) {
            enabledFeatures.multiViewport = VK_TRUE;
        }else {
            SPOOPY_LOG_WARN("GPU does not support multi viewports!\n");
        }

        VkDeviceCreateInfo deviceInfo = {};
        deviceInfo.sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
        deviceInfo.queueCreateInfoCount = static_cast<uint32_t>(queueFamily -> queueCreateInfos.size());
        deviceInfo.pQueueCreateInfos = queueFamily -> queueCreateInfos.data();

        if(instance.getEnabledValidationLayers()) {
            deviceInfo.enabledLayerCount = static_cast<uint32_t>(Devices::ValidationLayers.size());
            deviceInfo.ppEnabledLayerNames = Devices::ValidationLayers.data();
        }

        deviceInfo.enabledExtensionCount = static_cast<uint32_t>(Devices::Extensions.size());
        deviceInfo.ppEnabledExtensionNames = Devices::Extensions.data();
        deviceInfo.pEnabledFeatures = &enabledFeatures;
        checkVulkan(vkCreateDevice(physical.getPhysicalDevice(), &deviceInfo, nullptr, &logical));
        #endif
    }

    LogicalDevice::~LogicalDevice() {
        if(queueFamily != nullptr) {
            delete queueFamily;
        }
    }
}