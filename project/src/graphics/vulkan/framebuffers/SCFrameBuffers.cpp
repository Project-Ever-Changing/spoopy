#include "../SwapchainVulkan.h"
#include "../RenderPassVulkan.h"
#include "../images/ImageDepth.h"
#include "SCFrameBuffers.h"

namespace lime { namespace spoopy {
    SCFrameBuffers::SCFrameBuffers(const LogicalDevice &device, const SwapchainVulkan &swapchain, const RenderPassVulkan &renderPass,
        const ImageDepth* depthImage, const Vector2T_u32 &extent) {
        frameBuffers.resize(swapchain.GetImageCount());

        for(size_t i=0; i<frameBuffers.size(); i++) {
            /*
            std::vector<VkImageView> attachments = {
                swapchain.GetImageView(i)
            };
             */

            /*
            if(depthImage != nullptr) {
                attachments.emplace_back(depthImage->GetView());
            }

            frameBuffers[i] = std::make_unique<FrameBufferVulkan>(device, extent, 1, attachments, renderPass.GetRenderpass());
             */
        }
    }

    SCFrameBuffers::~SCFrameBuffers() {
        for(size_t i=0; i<frameBuffers.size(); i++) {
            frameBuffers[i].reset();
        }

        frameBuffers.clear();
    }
}}