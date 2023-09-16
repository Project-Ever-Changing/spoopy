#include "../graphics/vulkan/QueueVulkan.h"
#include "LogicalDevice.h"
#include "PhysicalDevice.h"
#include "Surface.h"
#include "Instance.h"

#include <spoopy_assert.h>

namespace lime { namespace spoopy {
    const std::vector<const char*> LogicalDevice::Extensions = {VK_KHR_SWAPCHAIN_EXTENSION_NAME, "VK_KHR_portability_subset"};

    LogicalDevice::LogicalDevice(const Instance &instance, const PhysicalDevice &physicalDevice)
        : instance(instance), physicalDevice(physicalDevice) {
        CreateLogicalDevice();
        RegisterDeviceLimits();
    }

    LogicalDevice::~LogicalDevice() {
        checkVulkan(vkDeviceWaitIdle(logicalDevice));
        vkDestroyDevice(logicalDevice, nullptr);
    }

    void LogicalDevice::CreateLogicalDevice() {
        uint32_t deviceQueueFamilyPropertyCount;
        vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice, &deviceQueueFamilyPropertyCount, nullptr);

        SP_ASSERT(deviceQueueFamilyPropertyCount >= 1);

        std::vector<VkQueueFamilyProperties> deviceQueueFamilyProperties(deviceQueueFamilyPropertyCount);
        vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice, &deviceQueueFamilyPropertyCount, deviceQueueFamilyProperties.data());

        std::vector<VkDeviceQueueCreateInfo> queueCreateInfos;
        queueCreateInfos.reserve(3);

        // Allocating to the heap to check if the queue is valid for each family was probably not the best idea.
        int32_t graphicsFamily, presentFamily, computeFamily, transferFamily = -1;

        for(uint32_t i=0; i<deviceQueueFamilyPropertyCount; i++) { // Also check if queue is valid for each family. That's all.
            const VkQueueFamilyProperties& curProps = deviceQueueFamilyProperties[i];
            bool isValid = false;

            if ((curProps.queueFlags & VK_QUEUE_GRAPHICS_BIT) == VK_QUEUE_GRAPHICS_BIT
                && (graphicsFamily == -1)) {
                graphicsFamily = i;
                isValid = true;
            }

            if((curProps.queueFlags & VK_QUEUE_COMPUTE_BIT) == VK_QUEUE_COMPUTE_BIT) {
                computeFamily = i;
                isValid = true;
            }

            if((curProps.queueFlags & VK_QUEUE_TRANSFER_BIT) == VK_QUEUE_TRANSFER_BIT
               && (transferFamily == -1 && (curProps.queueFlags & VK_QUEUE_GRAPHICS_BIT) != VK_QUEUE_GRAPHICS_BIT && (curProps.queueFlags & VK_QUEUE_COMPUTE_BIT) != VK_QUEUE_COMPUTE_BIT)) {
                transferFamily = i;
                isValid = true;
            }

            if(isValid) {
                SP_ASSERT(queueCreateInfos.size() < 3);
                float queuePriority[1] = { 1.0f };

                VkDeviceQueueCreateInfo queueCreateInfo = {};
                queueCreateInfo.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
                queueCreateInfo.queueFamilyIndex = i;
                queueCreateInfo.queueCount = curProps.queueCount;
                queueCreateInfo.pQueuePriorities = queuePriority;
                queueCreateInfos.emplace_back(queueCreateInfo);
            }
        }

        VkDeviceCreateInfo deviceCreateInfo = {};
        deviceCreateInfo.sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
        deviceCreateInfo.queueCreateInfoCount = static_cast<uint32_t>(queueCreateInfos.size());
        deviceCreateInfo.pQueueCreateInfos = queueCreateInfos.data();

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

        if(instance.GetEnableValidationLayers()) {
            deviceCreateInfo.enabledLayerCount = static_cast<uint32_t>(Instance::ValidationLayers.size());
            deviceCreateInfo.ppEnabledLayerNames = Instance::ValidationLayers.data();
        }

        deviceCreateInfo.enabledExtensionCount = static_cast<uint32_t>(Extensions.size());
        deviceCreateInfo.ppEnabledExtensionNames = Extensions.data();
        deviceCreateInfo.pEnabledFeatures = &enabledFeatures;

        checkVulkan(vkCreateDevice(physicalDevice, &deviceCreateInfo, nullptr, &logicalDevice));

        #ifndef SPOOPY_SWITCH
        volkLoadDevice(logicalDevice);
        #endif

        if(graphicsFamily == -1) {
            SPOOPY_LOG_ERROR("No graphics queue found for Vulkan!");
            return;
        }

        queues[P_Graphics] = std::make_shared<QueueVulkan>(*this, graphicsFamily);
        queues[P_Compute] = computeFamily != 1 ? std::make_shared<QueueVulkan>(*this, computeFamily) : queues[P_Graphics];
        queues[P_Transfer] = transferFamily != -1 ? std::make_shared<QueueVulkan>(*this, transferFamily) : queues[P_Graphics];
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

    void LogicalDevice::SetupPresentQueue(const Surface &surface) {
        if(queues[P_Present]) {
            return;
        }

        const auto supportsPresent = [surface](VkPhysicalDevice physicalDevice, QueueVulkan* queue) {
            VkBool32 supportsPresent = VK_FALSE;
            const uint32_t queueFamilyIndex = queue->GetFamilyIndex();
            checkVulkan(vkGetPhysicalDeviceSurfaceSupportKHR(physicalDevice, queueFamilyIndex, surface, &supportsPresent));
            return supportsPresent == VK_TRUE;
        };

        bool graphics = supportsPresent(physicalDevice, queues[P_Graphics].get());

        if(!graphics) {
            SPOOPY_LOG_ERROR("No graphics queue found for Vulkan!");
            return;
        }

        queues[P_Present] = queues[P_Graphics];
    }
}}