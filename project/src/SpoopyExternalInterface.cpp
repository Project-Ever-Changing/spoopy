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
            return;
        }

        SPOOPY_LOG_ERROR("No graphics module is currently active!");
    }
    DEFINE_PRIME0v(spoopy_check_graphics_module);

    void spoopy_update_graphics_module() {
        GraphicsModule::GetCurrent()->Update();
    }
    DEFINE_PRIME0v(spoopy_update_graphics_module);

    void spoopy_add_color_attachment(value renderpass, int location, int format) {
        RenderPassVulkan* renderPass = (RenderPassVulkan*)val_data(handle);

        #ifdef SPOOPY_VULKAN

        renderPass->AddColorAttachment(location, VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL, format, 1);

        #endif
    }
    DEFINE_PRIME3v(spoopy_add_color_attachment);

    void spoopy_add_depth_attachment(value renderpass, int location, int format) {
        RenderPassVulkan* renderPass = (RenderPassVulkan*)val_data(handle);

        #ifdef SPOOPY_VULKAN

        renderPass->AddDepthAttachment(location, VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL, format, 1);

        #endif
    }
    DEFINE_PRIME3v(spoopy_add_depth_attachment);

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