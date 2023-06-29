#include <system/CFFI.h>
#include <system/CFFIPointer.h>
#include <sdl_definitions_config.h>
#include <SDLWindow.h>

#ifdef SPOOPY_VULKAN
#include "graphics/vulkan/GraphicsVulkan.h"
#include "graphics/vulkan/ContextStage.h"
#include "graphics/vulkan/RenderPassVulkan.h"


typedef lime::spoopy::GraphicsVulkan GraphicsModule;
typedef lime::spoopy::RenderPassVulkan RenderPass;
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

    /*
     * If I name it spoopy_acquire_next_image_graphics_module, it will be too long.
     */
    void spoopy_acquire_image_graphics_module(value window_handle) {
        Window* window = (Window*)val_data(window_handle);
        SDLWindow* sdlWindow = static_cast<SDLWindow*>(window);
        GraphicsModule::GetCurrent()->AcquireNextImage(sdlWindow->context);
    }
    DEFINE_PRIME1v(spoopy_acquire_image_graphics_module);

    void spoopy_record_graphics_module(value window_handle, value renderpass_handle, value viewport_handle) {
        Window* window = (Window*)val_data(window_handle);
        SDLWindow* sdlWindow = static_cast<SDLWindow*>(window);
        RenderPass* renderPass = (RenderPass*)val_data(renderpass_handle);
        Viewport* viewport = (Viewport*)val_data(viewport_handle);

        GraphicsModule::GetCurrent()->Record(sdlWindow->context, *renderPass, *viewport);
    }
    DEFINE_PRIME3v(spoopy_record_graphics_module);

    void spoopy_reset_graphics_module(value renderpass_handle) {
        RenderPass* renderPass = (RenderPass*)val_data(renderpass_handle);
        GraphicsModule::GetCurrent()->Reset(*renderPass);
    }
    DEFINE_PRIME1v(spoopy_reset_graphics_module);

    void spoopy_add_color_attachment(value renderpass, int location, int format, bool hasImageLayout) {
        RenderPass* _renderPass = (RenderPass*)val_data(renderpass);

        #ifdef SPOOPY_VULKAN
        VkSampleCountFlagBits samples = GraphicsModule::GetCurrent()->MultisamplingEnabled
        ? GraphicsModule::GetCurrent()->GetPhysicalDevice()->GetMaxUsableSampleCount()
        : VK_SAMPLE_COUNT_1_BIT;
        VkImageLayout layout = hasImageLayout ? VK_IMAGE_LAYOUT_PRESENT_SRC_KHR : VK_IMAGE_LAYOUT_GENERAL;

        _renderPass->AddColorAttachment(location, VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL, format, samples, layout);
        #endif
    }
    DEFINE_PRIME4v(spoopy_add_color_attachment);

    void spoopy_add_depth_attachment(value renderpass, int location, int format, bool hasStencil) {
        RenderPass* _renderPass = (RenderPass*)val_data(renderpass);

        #ifdef SPOOPY_VULKAN
        VkSampleCountFlagBits samples = GraphicsModule::GetCurrent()->MultisamplingEnabled
        ? GraphicsModule::GetCurrent()->GetPhysicalDevice()->GetMaxUsableSampleCount()
        : VK_SAMPLE_COUNT_1_BIT;

        _renderPass->AddDepthAttachment(location, VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL, format, samples,
            VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL, VK_IMAGE_LAYOUT_UNDEFINED, hasStencil);
        #endif
    }
    DEFINE_PRIME4v(spoopy_add_depth_attachment);

    void spoopy_add_subpass_dependency(value renderpass, bool has_external1, bool has_external2, int srcStageMask,
        int dstStageMask, int srcAccessMask, int dstAccessMask, int dependencyFlags) {
        RenderPass* _renderPass = (RenderPass*)val_data(renderpass);

        #ifdef SPOOPY_VULKAN
        uint32_t _srcSubpass = has_external1 ? VK_SUBPASS_EXTERNAL : 0;
        uint32_t _dstSubpass = has_external2 ? VK_SUBPASS_EXTERNAL : 0;
        VkPipelineStageFlags _srcStageMask = (VkPipelineStageFlags)srcStageMask;
        VkPipelineStageFlags _dstStageMask = (VkPipelineStageFlags)dstStageMask;
        VkAccessFlags _srcAccessMask = (VkAccessFlags)srcAccessMask;
        VkAccessFlags _dstAccessMask = (VkAccessFlags)dstAccessMask;
        VkDependencyFlags _dependencyFlags = (VkDependencyFlags)dependencyFlags;

        _renderPass->AddSubpassDependency(_srcSubpass, _dstSubpass, _srcStageMask, _dstStageMask, _srcAccessMask,
            _dstAccessMask, _dependencyFlags);
        #endif
    }
    DEFINE_PRIME8v(spoopy_add_subpass_dependency);

    void spoopy_create_subpass(value renderpass) {
        RenderPass* _renderPass = (RenderPass*)val_data(renderpass);
        _renderPass->CreateSubpass();
    }
    DEFINE_PRIME1v(spoopy_create_subpass);

    void spoopy_create_renderpass(value renderpass) {
        RenderPass* _renderPass = (RenderPass*)val_data(renderpass);
        _renderPass->CreateRenderPass();
    }
    DEFINE_PRIME1v(spoopy_create_renderpass);

    void spoopy_check_context(value window_handle) {
        Window* window = (Window*)val_data(window_handle);
        SDLWindow* sdlWindow = static_cast<SDLWindow*>(window);
        SDL_Context context = sdlWindow->context;

        if(context != nullptr) {
            SPOOPY_LOG_SUCCESS("Window has a context!");
            return;
        }

        SPOOPY_LOG_ERROR("Window has no context!");
    }
    DEFINE_PRIME1v(spoopy_check_context);

    void spoopy_create_context_stage(value window_handle, value viewport) {
        Window* window = (Window*)val_data(window_handle);
        SDLWindow* sdlWindow = static_cast<SDLWindow*>(window);
        SDL_Context context = sdlWindow->context;
        context->stage = std::make_unique<ContextStage>(*context, Viewport(viewport));
    }
    DEFINE_PRIME2v(spoopy_create_context_stage);


    // Objects

    void spoopy_gc_render_pass(value handle) {
        RenderPass* _renderPass = (RenderPass*)val_data(handle);
        delete _renderPass;
    }

    value spoopy_create_render_pass() {
        RenderPass* _renderPass = new RenderPass(*GraphicsModule::GetCurrent()->GetLogicalDevice());
        return CFFIPointer(_renderPass, spoopy_gc_render_pass);
    }
    DEFINE_PRIME0(spoopy_create_render_pass);

    #endif
}}