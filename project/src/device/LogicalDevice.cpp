#include "../graphics/vulkan/CommandPoolVulkan.h"
#include "LogicalDevice.h"
#include "PhysicalDevice.h"
#include "Instance.h"

#include <spoopy_assert.h>

namespace lime { namespace spoopy {
    const std::vector<const char*> LogicalDevice::Extensions = {VK_KHR_SWAPCHAIN_EXTENSION_NAME, "VK_KHR_portability_subset",};

    LogicalDevice::LogicalDevice(const Instance &instance, const PhysicalDevice &physicalDevice)
        : instance(instance), physicalDevice(physicalDevice) {
        CreateQueueIndices();
        CreateLogicalDevice();
        RegisterDeviceLimits();
    }

    LogicalDevice::~LogicalDevice() {
        checkVulkan(vkDeviceWaitIdle(logicalDevice));
        vkDestroyDevice(logicalDevice, nullptr);
    }

    void LogicalDevice::CreateQueueIndices() {
        uint32_t deviceQueueFamilyPropertyCount;
        vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice, &deviceQueueFamilyPropertyCount, nullptr);

        SP_ASSERT(deviceQueueFamilyPropertyCount >= 1);

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
        queueCreateInfos.reserve(3);
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
            deviceCreateInfo.enabledLayerCount = static_cast<uint32_t>(Instance::ValidationLayers.size());
            deviceCreateInfo.ppEnabledLayerNames = Instance::ValidationLayers.data();
        }

        deviceCreateInfo.enabledExtensionCount = static_cast<uint32_t>(Extensions.size());
        deviceCreateInfo.ppEnabledExtensionNames = Extensions.data();
        deviceCreateInfo.pEnabledFeatures = &enabledFeatures;

        checkVulkan(vkCreateDevice(physicalDevice, &deviceCreateInfo, nullptr, &logicalDevice));
        volkLoadDevice(logicalDevice);

        vkGetDeviceQueue(logicalDevice, graphicsFamily, 0, &graphicsQueue);
        vkGetDeviceQueue(logicalDevice, presentFamily, 0, &presentQueue);
        vkGetDeviceQueue(logicalDevice, computeFamily, 0, &computeQueue);
        vkGetDeviceQueue(logicalDevice, transferFamily, 0, &transferQueue);

        graphicsCommandPools.emplace(std::this_thread::get_id(), std::make_shared<CommandPoolVulkan>(*this, graphicsFamily));
    }

    void LogicalDevice::RegisterDeviceLimits() {
        VkPhysicalDeviceLimits physicalDeviceLimits = physicalDevice.GetProperties().limits;
        limits.HasComputeShaders = physicalDeviceLimits.maxComputeWorkGroupCount[0] >= 65535 && physicalDeviceLimits.maxComputeWorkGroupCount[1] >= 65535;

        #if defined(HX_MACOS) || defined(HX_IOS)
        limits.HasTessellationShaders = false;
        #else
        limits.HasTessellationShaders = !!physicalDevice.GetFeatures().tessellationShader && physicalDeviceLimits.maxBoundDescriptorSets >= 4;
        #endif

        /*
         * I assume Metal 3's mesh shaders will be supported on macOS and iOS, which would allow
         * MoltenVK to support geometry shaders on these platforms. This might be wishful thinking though.
         */
        limits.HasGeometryShaders = !!physicalDevice.GetFeatures().geometryShader;

        limits.HasIndirectDrawing = physicalDeviceLimits.maxDrawIndirectCount >= 1;
        limits.HasMultisampleDepthAsSampler = !!physicalDevice.GetFeatures().sampleRateShading;
        limits.MaxTexture1DSize = physicalDeviceLimits.maxImageDimension1D;
        limits.MaxTexture2DSize = physicalDeviceLimits.maxImageDimension2D;
        limits.MaxTexture3DSize = physicalDeviceLimits.maxImageDimension3D;
        limits.MaxTexture1DArraySize = physicalDeviceLimits.maxImageArrayLayers;
        limits.MaxTexture2DArraySize = physicalDeviceLimits.maxImageArrayLayers;
        limits.MaxTextureCubeSize = physicalDeviceLimits.maxImageDimensionCube;
        limits.MaxAnisotropy = physicalDeviceLimits.maxSamplerAnisotropy;
    }

    VkQueue LogicalDevice::GetQueue(const VkQueueFlagBits queueFamilyIndex) const {
        switch(queueFamilyIndex) {
            case VK_QUEUE_GRAPHICS_BIT:
                return graphicsQueue;
            case VK_QUEUE_COMPUTE_BIT:
                return computeQueue;
            case VK_QUEUE_TRANSFER_BIT:
                return transferQueue;
            default:
                SPOOPY_LOG_ERROR("Invalid queue family index!");
                return VK_NULL_HANDLE;
        }
    }

    const std::shared_ptr<CommandPoolVulkan> &LogicalDevice::GetGraphicsCommandPool(const std::thread::id &threadId) {
        try {
            return graphicsCommandPools.at(threadId);
        }catch(const std::out_of_range& e) {
            throw std::runtime_error("No graphics command pool for thread!");
        }
    }
}}