#include "../../device/Surface.h"
#include "../../device/PhysicalDevice.h"
#include "../../device/LogicalDevice.h"
#include "../../../include/graphics/ContextLayer.h"
#include "SwapchainVulkan.h"
#include "ContextStage.h"
#include "QueueVulkan.h"

#include <system/ScopeLock.h>
#include <graphics/ContextLayer.h>

namespace lime { namespace spoopy {
    ContextVulkan::ContextVulkan(const std::shared_ptr<QueueVulkan> &queue)
    : queue(queue)
    , swapchain(nullptr)
    , oldSwapchain(VK_NULL_HANDLE)
    , vsync(false) {

    }

    ContextVulkan::~ContextVulkan() {
        if(swapchain != nullptr) {
            delete swapchain;
            swapchain = nullptr;
        }
    }

    bool ContextVulkan::RecreateSwapchainWrapper(int width, int height) {
        ScopeLock lock(swapchainMutex);

        if(swapchain->GetWidth() == width && swapchain->GetHeight() == height) {
            return false;
        }

        queue->GetDevice().WaitForGPU();
        coreRecreateSwapchain->Call(&width, &height);
        return true;
    }

    uint32_t ContextVulkan::GetImageCount() const {
        if(!swapchain) {
            SPOOPY_LOG_WARN("Attempted to get image count without a swapchain!");
            return 0;
        }

        //return swapchain->GetImageCount();
        return 0;
    }

    void ContextVulkan::InitSwapchain(int32 width, int32 height, const PhysicalDevice &physicalDevice) {
        swapchain = new SwapchainVulkan(width, height, oldSwapchain, vsync, queue->GetDevice(), physicalDevice, *this);
    }

    void ContextVulkan::DestroySwapchain() {
        swapchain->Destroy(oldSwapchain);
    }
}}