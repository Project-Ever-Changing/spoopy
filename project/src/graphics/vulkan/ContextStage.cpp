#include "GraphicsVulkan.h"
#include "RenderPassVulkan.h"
#include "../../../include/graphics/ContextLayer.h"
#include "ContextStage.h"

namespace lime { namespace spoopy {
    ContextStage::ContextStage(const ContextVulkan &context, const Viewport &viewport):
        context(context),
        viewport(viewport),
        isDirty(true) {
        // Empty for now.
    }

    ContextStage::~ContextStage() {

    }

    void ContextStage::SetViewport(const Viewport &viewport) {
        if(this->viewport.offset != viewport.offset || this->viewport.extent != viewport.extent) {
            this->viewport.SetTo(viewport);
            isDirty = true;
        }
    }

    void ContextStage::UpdateViewport(const VkCommandBuffer &commandBuffer) {
        VkViewport vkViewport = {};
        vkViewport.x = static_cast<float>(viewport.offset.x);
        vkViewport.y = static_cast<float>(viewport.offset.y);
        vkViewport.width = static_cast<float>(viewport.extent.x);
        vkViewport.height = static_cast<float>(viewport.extent.y);
        vkViewport.minDepth = 0.0f;
        vkViewport.maxDepth = 1.0f;
        vkCmdSetViewport(commandBuffer, 0, 1, &vkViewport);
    }

    void ContextStage::Update() {
        renderArea.SetOffset(viewport.offset);
        renderArea.SetExtent(viewport.extent);

        renderArea.UpdateAspectRatio();
        renderArea.SetExtent(renderArea.GetExtent() + renderArea.GetOffset());
    }
}}