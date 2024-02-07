#include "../graphics/vulkan/QueueVulkan.h"
#include "LogicalDevice.h"
#include "PhysicalDevice.h"
#include "Surface.h"
#include "Instance.h"

#include <spoopy_assert.h>

namespace lime { namespace spoopy {
    const std::vector<const char*> LogicalDevice::Extensions = {VK_KHR_SWAPCHAIN_EXTENSION_NAME, "VK_KHR_portability_subset"};

    LogicalDevice::LogicalDevice(const Instance &instance, const PhysicalDevice &physicalDevice)
        : instance(instance)
        , physicalDevice(physicalDevice)
        , allocator(VK_NULL_HANDLE) {
        CreateLogicalDevice();
        RegisterDeviceLimits();
    }

    LogicalDevice::~LogicalDevice() {
        #ifdef SPOOPY_DEBUG
        SPOOPY_LOG_INFO("Destroying logical device");
        #endif

        checkVulkan(vkDeviceWaitIdle(logicalDevice));
        vkDestroyDevice(logicalDevice, nullptr);
    }

    void LogicalDevice::CreateLogicalDevice() {
        uint32_t deviceQueueFamilyPropertyCount;
        vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice.GetPhysicalDevice(), &deviceQueueFamilyPropertyCount, nullptr);

        SP_ASSERT(deviceQueueFamilyPropertyCount >= 1);

        std::vector<VkQueueFamilyProperties> deviceQueueFamilyProperties(deviceQueueFamilyPropertyCount);
        vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice.GetPhysicalDevice(), &deviceQueueFamilyPropertyCount, deviceQueueFamilyProperties.data());

        std::vector<VkDeviceQueueCreateInfo> queueCreateInfos;
        queueCreateInfos.reserve(3);

        // Allocating to the heap to check if the queue is valid for each family was probably not the best idea.
        int32_t graphicsFamily = -1, presentFamily = -1, computeFamily = -1, transferFamily = -1;

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

        #ifdef SPOOPY_DEBUG

        uint32_t layerCount;
        vkEnumerateDeviceLayerProperties(physicalDevice.GetPhysicalDevice(), &layerCount, nullptr);
        std::vector<VkLayerProperties> availableLayers(layerCount);
        vkEnumerateDeviceLayerProperties(physicalDevice.GetPhysicalDevice(), &layerCount, availableLayers.data());

        Instance::AddValidationLayers(availableLayers, validationLayers);
        deviceCreateInfo.ppEnabledLayerNames = validationLayers.data();
        deviceCreateInfo.enabledLayerCount = static_cast<uint32_t>(validationLayers.size());

        #endif

        deviceCreateInfo.enabledExtensionCount = static_cast<uint32_t>(Extensions.size());
        deviceCreateInfo.ppEnabledExtensionNames = Extensions.data();
        deviceCreateInfo.pEnabledFeatures = &enabledFeatures;

        checkVulkan(vkCreateDevice(physicalDevice.GetPhysicalDevice(), &deviceCreateInfo, nullptr, &logicalDevice));

        #ifndef SPOOPY_SWITCH
        volkLoadDevice(logicalDevice);
        #endif

        if(graphicsFamily == -1) {
            SPOOPY_LOG_ERROR("No graphics queue found for Vulkan!");
            return;
        }

        queues[P_Graphics] = std::make_shared<QueueVulkan>(*this, graphicsFamily);
        queues[P_Compute] = computeFamily != -1 ? std::make_shared<QueueVulkan>(*this, computeFamily) : queues[P_Graphics];
        queues[P_Transfer] = transferFamily != -1 ? std::make_shared<QueueVulkan>(*this, transferFamily) : queues[P_Graphics];
    }

    void LogicalDevice::RegisterDeviceLimits() {
        physicalDeviceLimits = physicalDevice.GetProperties().limits;
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

        // CreateAllocator();
    }

    void LogicalDevice::CreateAllocator() {
        VmaVulkanFunctions vulkanFunctions;
        vulkanFunctions.vkGetInstanceProcAddr = vkGetInstanceProcAddr;
        vulkanFunctions.vkGetDeviceProcAddr = vkGetDeviceProcAddr;
        vulkanFunctions.vkAllocateMemory = vkAllocateMemory;
        vulkanFunctions.vkBindBufferMemory = vkBindBufferMemory;
        vulkanFunctions.vkBindImageMemory = vkBindImageMemory;
        vulkanFunctions.vkCreateBuffer = vkCreateBuffer;
        vulkanFunctions.vkCreateImage = vkCreateImage;
        vulkanFunctions.vkDestroyBuffer = vkDestroyBuffer;
        vulkanFunctions.vkDestroyImage = vkDestroyImage;
        vulkanFunctions.vkFreeMemory = vkFreeMemory;
        vulkanFunctions.vkGetBufferMemoryRequirements = vkGetBufferMemoryRequirements;
        vulkanFunctions.vkGetBufferMemoryRequirements2KHR = vkGetBufferMemoryRequirements2;
        vulkanFunctions.vkGetImageMemoryRequirements = vkGetImageMemoryRequirements;
        vulkanFunctions.vkGetImageMemoryRequirements2KHR = vkGetImageMemoryRequirements2;
        vulkanFunctions.vkGetPhysicalDeviceMemoryProperties = vkGetPhysicalDeviceMemoryProperties;
        vulkanFunctions.vkGetPhysicalDeviceProperties = vkGetPhysicalDeviceProperties;
        vulkanFunctions.vkMapMemory = vkMapMemory;
        vulkanFunctions.vkUnmapMemory = vkUnmapMemory;
        vulkanFunctions.vkFlushMappedMemoryRanges = vkFlushMappedMemoryRanges;
        vulkanFunctions.vkInvalidateMappedMemoryRanges = vkInvalidateMappedMemoryRanges;
        vulkanFunctions.vkCmdCopyBuffer = vkCmdCopyBuffer;

        #if VMA_DEDICATED_ALLOCATION
        vulkanFunctions.vkGetBufferMemoryRequirements2KHR = vkGetBufferMemoryRequirements2;
        vulkanFunctions.vkGetImageMemoryRequirements2KHR = vkGetImageMemoryRequirements2;
        #endif

        #if VMA_BIND_MEMORY2
        vulkanFunctions.vkBindBufferMemory2KHR = vkBindBufferMemory2;
        vulkanFunctions.vkBindImageMemory2KHR = vkBindImageMemory2;
        #endif

        #if VMA_MEMORY_BUDGET
        vulkanFunctions.vkGetPhysicalDeviceMemoryProperties2KHR = vkGetPhysicalDeviceMemoryProperties2;
        #endif

        VmaAllocatorCreateInfo allocatorInfo = {};
        allocatorInfo.physicalDevice = physicalDevice.GetPhysicalDevice();
        allocatorInfo.device = logicalDevice;
        allocatorInfo.instance = instance;
        allocatorInfo.pVulkanFunctions = &vulkanFunctions;

        #ifndef SPOOPY_SWITCH
        allocatorInfo.vulkanApiVersion = volkGetInstanceVersion();
        #else
        allocatorInfo.vulkanApiVersion = VK_API_VERSION_1_1;
        #endif

        VkResult result = vmaCreateAllocator(&allocatorInfo, &allocator);
        SP_ASSERT(result == VK_SUCCESS);
    }

    void LogicalDevice::SetupPresentQueue(const Surface &surface) {
        if(queues[P_Present]) {
            return;
        }

        const auto supportsPresent = [surface](VkPhysicalDevice pDevice, QueueVulkan* queue) {
            VkBool32 supportsPresent = VK_FALSE;
            const uint32_t queueFamilyIndex = queue->GetFamilyIndex();
            checkVulkan(vkGetPhysicalDeviceSurfaceSupportKHR(pDevice, queueFamilyIndex, surface, &supportsPresent));
            return supportsPresent == VK_TRUE;
        };

        bool graphics = supportsPresent(physicalDevice.GetPhysicalDevice(), queues[P_Graphics].get());

        if(!graphics) {
            SPOOPY_LOG_ERROR("No graphics queue found for Vulkan!");
            return;
        }

        queues[P_Present] = queues[P_Graphics];
    }

    void LogicalDevice::WaitForGPU() {
        if(logicalDevice != VK_NULL_HANDLE) checkVulkan(vkDeviceWaitIdle(logicalDevice));
    }

    VkResult LogicalDevice::CreateHostBuffer(uint32_t size, VkBuffer* buffer, VmaAllocation* allocation
    , VmaMemoryUsage usage) {
        VkBufferCreateInfo bufferCreateInfo = {};
        bufferCreateInfo.sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
        bufferCreateInfo.size = size;
        bufferCreateInfo.usage = VK_BUFFER_USAGE_TRANSFER_SRC_BIT | VK_BUFFER_USAGE_TRANSFER_DST_BIT;
        bufferCreateInfo.sharingMode = VK_SHARING_MODE_EXCLUSIVE;

        VmaAllocationCreateInfo allocationCreateInfo = {};
        allocationCreateInfo.usage = usage;

        return vmaCreateBuffer(allocator, &bufferCreateInfo, &allocationCreateInfo, buffer, allocation, nullptr);
    }

    // At first, I thought of using a binary search, but I think linear is fine.
    bool LogicalDevice::FindInstanceExtensions(const char* extensionName) const {
        uint32_t availableExtensionCount = 0;
        vkEnumerateInstanceExtensionProperties(nullptr, &availableExtensionCount, nullptr);
        std::vector<VkExtensionProperties> availableExtensions(availableExtensionCount);
        vkEnumerateInstanceExtensionProperties(nullptr, &availableExtensionCount, availableExtensions.data());

        for(const auto &extension: availableExtensions) {
            if(platform::stringCompare(extension.extensionName, extensionName) == 0) {
                return true;
            }
        }

        return false;
    }
}}