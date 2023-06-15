#include <system/CFFI.h>
#include <system/CFFIPointer.h>
//#include <shaders/CrossShader.h>

#ifdef SPOOPY_VULKAN
#include "graphics/vulkan/GraphicsVulkan.h"
#include "graphics/vulkan/RenderPassVulkan.h"

typedef lime::spoopy::GraphicsVulkan GraphicsModule;
#endif

namespace lime { namespace spoopy {

    #ifndef LIME_OPENGL

    void spoopy_check_graphics_module() {
        if(GraphicsModule::GetCurrent() != nullptr) {
            SPOOPY_LOG_SUCCESS("Graphics module is currently active!");
            return;
        }

        SPOOPY_LOG_ERROR("No graphics module is currently active!");
    }
    DEFINE_PRIME0v(spoopy_check_graphics_module);

    void spoopy_update_graphics_module() {
        GraphicsModule::GetCurrent()->Update();
    }
    DEFINE_PRIME0v(spoopy_update_graphics_module);

    void spoopy_add_color_attachment(value renderpass, int location, int format, bool hasImageLayout) {
        RenderPassVulkan* renderPass = (RenderPassVulkan*)val_data(renderpass);

        #ifdef SPOOPY_VULKAN
        VkSampleCountFlagBits samples = GraphicsModule::GetCurrent()->MultisamplingEnabled
        ? GraphicsModule::GetCurrent()->GetPhysicalDevice()->GetMaxUsableSampleCount()
        : VK_SAMPLE_COUNT_1_BIT;
        VkImageLayout layout = hasImageLayout ? VK_IMAGE_LAYOUT_PRESENT_SRC_KHR : VK_IMAGE_LAYOUT_GENERAL;

        renderPass->AddColorAttachment(location, VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL, format, samples, layout);
        #endif
    }
    DEFINE_PRIME4v(spoopy_add_color_attachment);

    void spoopy_add_depth_attachment(value renderpass, int location, int format, bool hasStencil) {
        RenderPassVulkan* renderPass = (RenderPassVulkan*)val_data(renderpass);

        #ifdef SPOOPY_VULKAN
        VkSampleCountFlagBits samples = GraphicsModule::GetCurrent()->MultisamplingEnabled
        ? GraphicsModule::GetCurrent()->GetPhysicalDevice()->GetMaxUsableSampleCount()
        : VK_SAMPLE_COUNT_1_BIT;

        renderPass->AddDepthAttachment(location, VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL, format, samples,
            VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL, VK_IMAGE_LAYOUT_UNDEFINED, hasStencil);
        #endif
    }
    DEFINE_PRIME4v(spoopy_add_depth_attachment);

    // Objects

    void spoopy_gc_render_pass(value handle) {
        RenderPassVulkan* renderPass = (RenderPassVulkan*)val_data(handle);
        delete renderPass;
    }

    value spoopy_create_render_pass() {
        RenderPassVulkan* renderPass = new RenderPassVulkan(*GraphicsModule::GetCurrent()->GetLogicalDevice());
        return CFFIPointer(renderPass, spoopy_gc_render_pass);
    }
    DEFINE_PRIME0(spoopy_create_render_pass);

    #endif
}}