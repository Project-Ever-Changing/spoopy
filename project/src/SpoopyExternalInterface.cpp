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


    // Objects

    void spoopy_gc_render_pass(value handle) {
        RenderPassVulkan* renderPass = (RenderPassVulkan*)val_data(handle);
        delete renderPass;
    }

    value spoopy_create_render_pass(int location, int format) {
        RenderPassVulkan* renderPass = new RenderPassVulkan(*GraphicsModule::GetCurrent()->GetLogicalDevice());
        return CFFIPointer(renderPass, spoopy_gc_render_pass);
    }
    DEFINE_PRIME2(spoopy_create_render_pass);

    #endif
}}