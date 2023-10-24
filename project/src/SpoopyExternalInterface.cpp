#include <system/CFFI.h>
#include <system/CFFIPointer.h>
#include <utils/MemoryReader.h>
#include <sdl_definitions_config.h>
#include <SDLWindow.h>

#ifdef SPOOPY_VULKAN
#include "graphics/vulkan/GraphicsVulkan.h"
#include "graphics/vulkan/ContextStage.h"
#include "graphics/vulkan/RenderPassVulkan.h"
#include "graphics/vulkan/PipelineVulkan.h"
#include "graphics/vulkan/components/CommandPoolVulkan.h"
#include "graphics/vulkan/components/SemaphoreVulkan.h"
#include "graphics/vulkan/CommandBufferVulkan.h"
#include "graphics/vulkan/QueueVulkan.h"
#include "graphics/vulkan/EntryVulkan.h"


typedef lime::spoopy::GraphicsVulkan GraphicsModule;
typedef lime::spoopy::RenderPassVulkan RenderPass;
typedef lime::spoopy::PipelineVulkan Pipeline;
typedef lime::spoopy::CommandPoolVulkan CommandPool;
typedef lime::spoopy::CommandBufferVulkan CommandBuffer;
typedef lime::spoopy::SemaphoreVulkan Semaphore;
typedef std::shared_ptr<lime::spoopy::QueueVulkan> Queue;
typedef lime::spoopy::EntryVulkan Entry;
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

    void spoopy_resize_graphics_context(value window_handle, value viewport) {
        Window* window = (Window*)val_data(window_handle);
        SDLWindow* sdlWindow = static_cast<SDLWindow*>(window);

        GraphicsModule::GetCurrent()->ChangeSize(sdlWindow->context, Viewport(viewport));
    }
    DEFINE_PRIME2v(spoopy_resize_graphics_context);

    void spoopy_add_color_attachment(value renderpass, int location, int format, bool hasImageLayout, bool sampled) {
        RenderPass* _renderPass = (RenderPass*)val_data(renderpass);

        #ifdef SPOOPY_VULKAN
        VkSampleCountFlagBits samples = (GraphicsModule::GetCurrent()->MultisamplingEnabled && sampled)
        ? GraphicsModule::GetCurrent()->GetPhysicalDevice()->GetMaxUsableSampleCount()
        : VK_SAMPLE_COUNT_1_BIT;
        VkImageLayout layout = hasImageLayout ? VK_IMAGE_LAYOUT_PRESENT_SRC_KHR : VK_IMAGE_LAYOUT_GENERAL;

        _renderPass->AddColorAttachment(location, VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL, format, samples, layout);
        #endif
    }
    DEFINE_PRIME5v(spoopy_add_color_attachment);

    void spoopy_add_depth_attachment(value renderpass, int location, int format, bool hasStencil, bool sampled) {
        RenderPass* _renderPass = (RenderPass*)val_data(renderpass);

        #ifdef SPOOPY_VULKAN
        VkSampleCountFlagBits samples = (GraphicsModule::GetCurrent()->MultisamplingEnabled && sampled)
        ? GraphicsModule::GetCurrent()->GetPhysicalDevice()->GetMaxUsableSampleCount()
        : VK_SAMPLE_COUNT_1_BIT;

        _renderPass->AddDepthAttachment(location, VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL, format, samples,
            VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL, VK_IMAGE_LAYOUT_UNDEFINED, hasStencil);
        #endif
    }
    DEFINE_PRIME5v(spoopy_add_depth_attachment);

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
        Context context = sdlWindow->context;

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
        Context context = sdlWindow->context;
        context->stage = std::make_unique<ContextStage>(*context, Viewport(viewport));
    }
    DEFINE_PRIME2v(spoopy_create_context_stage);


    // Objects

    void spoopy_gc_render_pass(value handle) {
        RenderPass* _renderPass = (RenderPass*)val_data(handle);
        delete _renderPass;
    }

    void spoopy_gc_pipeline(value handle) {
        Pipeline* _pipeline = (Pipeline*)val_data(handle);
        delete _pipeline;
    }

    void spoopy_gc_command_pool(value handle) {
        CommandPool* _commandPool = (CommandPool*)val_data(handle);
        delete _commandPool;
    }

    void spoopy_gc_command_buffer(value handle) {
        CommandBuffer* _commandBuffer = (CommandBuffer*)val_data(handle);
        delete _commandBuffer;
    }

    void spoopy_gc_memory_reader(value handle) {
        MemoryReader* _memoryReader = (MemoryReader*)val_data(handle);
        delete _memoryReader;
    }

    void spoopy_gc_semaphore(value handle) {
        Semaphore* _semaphore = (Semaphore*)val_data(handle);
        delete _semaphore;
    }

    void spoopy_gc_entry(value handle) {
        Entry* _entry = (Entry*)val_data(handle);
        delete _entry;
    }

    value spoopy_create_render_pass() {
        RenderPass* _renderPass = new RenderPass(*GraphicsModule::GetCurrent()->GetLogicalDevice());
        return CFFIPointer(_renderPass, spoopy_gc_render_pass);
    }
    DEFINE_PRIME0(spoopy_create_render_pass);

    /*
     * This is a interesting way of doing things,
     * making HxString as a container of bytes.
     */
    value spoopy_create_memory_reader(HxString data, int size) {
        MemoryReader* _memoryReader = new MemoryReader((std::byte*)data.c_str(), (uint32_t)size);
        return CFFIPointer(_memoryReader, spoopy_gc_memory_reader);
    }
    DEFINE_PRIME2(spoopy_create_memory_reader);

    value spoopy_create_pipeline() {
        Pipeline *_pipeline = new Pipeline(*GraphicsModule::GetCurrent()->GetLogicalDevice());
        return CFFIPointer(_pipeline, spoopy_gc_pipeline);
    }
    DEFINE_PRIME0(spoopy_create_pipeline);

    value spoopy_create_command_pool(value window_handle) {
        Window* window = (Window*)val_data(window_handle);
        SDLWindow* sdlWindow = static_cast<SDLWindow*>(window);
        Context context = sdlWindow->context;

        CommandPool* _commandPool = new CommandPool(*GraphicsModule::GetCurrent()->GetLogicalDevice(), context->GetQueue()->GetFamilyIndex());
        return CFFIPointer(_commandPool, spoopy_gc_command_pool);
    }
    DEFINE_PRIME1(spoopy_create_command_pool);

    value spoopy_create_command_buffer(value command_pool, bool begin) {
        CommandPool* _commandPool = (CommandPool*)val_data(command_pool);
        CommandBuffer* _commandBuffer = new CommandBuffer(_commandPool, begin);
        return CFFIPointer(_commandBuffer, spoopy_gc_command_buffer);
    }
    DEFINE_PRIME2(spoopy_create_command_buffer);

    value spoopy_create_semaphore() {
        Semaphore* _semaphore = new Semaphore(*GraphicsModule::GetCurrent()->GetLogicalDevice());
        return CFFIPointer(_semaphore, spoopy_gc_semaphore);
    }
    DEFINE_PRIME0(spoopy_create_semaphore);

    value spoopy_create_entry(value window_handle) {
        Window* window = (Window*)val_data(window_handle);
        SDLWindow* sdlWindow = static_cast<SDLWindow*>(window);
        Context context = sdlWindow->context;

        Entry* _entry = new Entry(*context->GetQueue());
        return CFFIPointer(_entry, spoopy_gc_entry);
    }

    void spoopy_pipeline_set_input_assembly(value pipeline, int topology) {
        Pipeline* _pipeline = (Pipeline*)val_data(pipeline);
        _pipeline->SetInputAssembly((PrimTopologyType)topology);
    }
    DEFINE_PRIME2v(spoopy_pipeline_set_input_assembly);

    void spoopy_pipeline_set_vertex_input(value pipeline, value memory_reader) {
        MemoryReader* _memoryReader = (MemoryReader*)val_data(memory_reader);
        Pipeline* _pipeline = (Pipeline*)val_data(pipeline);

        _pipeline->SetVertexInput(*_memoryReader);
    }
    DEFINE_PRIME2v(spoopy_pipeline_set_vertex_input);

    int spoopy_get_memory_length(value memory_reader) {
        MemoryReader* _memoryReader = (MemoryReader*)val_data(memory_reader);
        return _memoryReader->length;
    }
    DEFINE_PRIME1(spoopy_get_memory_length);

    HxString spoopy_get_memory_data(value memory_reader) {
        MemoryReader* _memoryReader = (MemoryReader*)val_data(memory_reader);
        return HxString((char*)_memoryReader->data);
    }
    DEFINE_PRIME1(spoopy_get_memory_data);

    int spoopy_get_memory_position(value memory_reader) {
        MemoryReader* _memoryReader = (MemoryReader*)val_data(memory_reader);
        return _memoryReader->GetPosition();
    }
    DEFINE_PRIME1(spoopy_get_memory_position);

    #endif
}}