#include <system/CFFI.h>
#include <system/CFFIPointer.h>
#include <system/Semaphore.h>
#include <utils/MemoryReader.h>
#include <core/Engine.h>

#include <sdl_definitions_config.h>
#include <SDLWindow.h>

#ifdef SPOOPY_VULKAN

#include "graphics/vulkan/GraphicsVulkan.h"
#include "graphics/vulkan/ContextStage.h"
#include "graphics/vulkan/RenderPassVulkan.h"
#include "graphics/vulkan/components/CommandPoolVulkan.h"
#include "graphics/vulkan/CommandBufferVulkan.h"
#include "graphics/vulkan/QueueVulkan.h"
#include "graphics/vulkan/EntryVulkan.h"


typedef lime::spoopy::GraphicsVulkan GraphicsModule;
typedef lime::spoopy::RenderPassVulkan RenderPass;
typedef lime::spoopy::CommandPoolVulkan CommandPool;
typedef lime::spoopy::CommandBufferVulkan CommandBuffer;
typedef std::shared_ptr<lime::spoopy::QueueVulkan> Queue;
typedef lime::spoopy::EntryVulkan Entry;

#endif

namespace lime { namespace spoopy {

    #ifndef LIME_OPENGL

    void spoopy_check_graphics_module() {
        if(GraphicsModule::GetCurrent()) {
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

    void spoopy_device_lock_fence() {
        GraphicsModule::GetCurrent()->GetLogicalDevice()->fenceMutex.Lock();
    }
    DEFINE_PRIME0v(spoopy_device_lock_fence);

    void spoopy_device_unlock_fence() {
        GraphicsModule::GetCurrent()->GetLogicalDevice()->fenceMutex.Unlock();
    }
    DEFINE_PRIME0v(spoopy_device_unlock_fence);

    void spoopy_device_init_swapchain(value window_handle, value callback) {
        Window* window = (Window*)val_data(window_handle);
        SDLWindow* sdlWindow = static_cast<SDLWindow*>(window);
        Context context = sdlWindow->context;

        int32 width, height;
        GetDrawableSize(sdlWindow->sdlWindow, &width, &height);

        if(context->GetSwapchain() || context->coreRecreateSwapchain) {
            SPOOPY_LOG_ERROR("Attempted to hook a callback to the swapchain recreate callback when one already exists!");
            return;
        }

        if(!val_is_function(callback)) {
            SPOOPY_LOG_ERROR("Attempted to hook a non-function to the swapchain recreate callback!");
            return;
        }

        if(context->coreRecreateSwapchain) {
            delete context->coreRecreateSwapchain;
        }

        const PhysicalDevice& physicalDevice = *GraphicsModule::GetCurrent()->GetPhysicalDevice();
        context->InitSwapchain(width, height, physicalDevice);
        context->coreRecreateSwapchain = new ValuePointer(callback);
    }
    DEFINE_PRIME2v(spoopy_device_init_swapchain);

    void spoopy_device_create_swapchain(value window_handle) {
        Window* window = (Window*)val_data(window_handle);
        SDLWindow* sdlWindow = static_cast<SDLWindow*>(window);
        Context context = sdlWindow->context;

        if(!context->coreRecreateSwapchain) {
            SPOOPY_LOG_ERROR("Attempted to create a swapchain without a callback!");
            return;
        }

        context->CreateSwapchain();
    }
    DEFINE_PRIME1v(spoopy_device_create_swapchain);

    void spoopy_device_destroy_swapchain(value window_handle) {
        Window* window = (Window*)val_data(window_handle);
        SDLWindow* sdlWindow = static_cast<SDLWindow*>(window);
        Context context = sdlWindow->context;

        if(!context->GetSwapchain()) {
            SPOOPY_LOG_ERROR("Attempted to destroy a swapchain that doesn't exist!");
            return;
        }

        context->DestroySwapchain();
    }
    DEFINE_PRIME1v(spoopy_device_destroy_swapchain);

    int spoopy_device_get_swapchain_image_count(value window_handle) {
        Window* window = (Window*)val_data(window_handle);
        SDLWindow* sdlWindow = static_cast<SDLWindow*>(window);
        Context context = sdlWindow->context;

        return (int)context->GetSwapchain()->GetImageCount();
    }
    DEFINE_PRIME1(spoopy_device_get_swapchain_image_count);

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

        if(context) {
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

    value spoopy_create_entry(value window_handle) {
        Window* window = (Window*)val_data(window_handle);
        SDLWindow* sdlWindow = static_cast<SDLWindow*>(window);
        Context context = sdlWindow->context;

        Entry* _entry = new Entry(*context->GetQueue());
        return CFFIPointer(_entry, spoopy_gc_entry);
    }
    DEFINE_PRIME1(spoopy_create_entry);

    bool spoopy_entry_is_gpu_operation_complete(value entry) {
        Entry* _entry = (Entry*)val_data(entry);
        return _entry->IsGPUOperationComplete();
    }
    DEFINE_PRIME1(spoopy_entry_is_gpu_operation_complete);

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


    /*
     * Engine Semaphore API
     */
    void spoopy_gc_threading_semaphore(value handle) {
        Semaphore* _semaphore = (Semaphore*)val_data(handle);
        delete _semaphore;
    }

    value spoopy_create_threading_semaphore() {
        Semaphore* _semaphore = new Semaphore();
        return CFFIPointer(_semaphore, spoopy_gc_threading_semaphore);
    }
    DEFINE_PRIME0(spoopy_create_threading_semaphore);

    void spoopy_threading_semaphore_wait(value semaphore) {
        Semaphore* _semaphore = (Semaphore*)val_data(semaphore);
        _semaphore->Wait();
    }
    DEFINE_PRIME1v(spoopy_threading_semaphore_wait);

    void spoopy_threading_semaphore_set(value semaphore) {
        Semaphore* _semaphore = (Semaphore*)val_data(semaphore);
        _semaphore->Set();
    }
    DEFINE_PRIME1v(spoopy_threading_semaphore_set);

    void spoopy_threading_semaphore_destroy(value semaphore) {
        Semaphore* _semaphore = (Semaphore*)val_data(semaphore);
        _semaphore->Destroy();
    }
    DEFINE_PRIME1v(spoopy_threading_semaphore_destroy);


    /*
     * Engine API
     */

    extern "C" {
        void spoopy_engine_bind_callbacks(value updateCallback, value drawCallback) {
            if (!val_is_function(updateCallback)) {
                SPOOPY_LOG_ERROR("Update callback is not a function!");
                return;
            }

            if (!val_is_function(drawCallback)) {
                SPOOPY_LOG_ERROR("Draw callback is not a function!");
                return;
            }

            Engine::GetInstance()->BindCallbacks(updateCallback, drawCallback);
        }
        DEFINE_PRIME2v(spoopy_engine_bind_callbacks);

        void spoopy_engine_apply(bool cpuLimiterEnabled, float updateFPS, float drawFPS, float timeScale) {
            if(updateFPS < drawFPS) {
                SPOOPY_LOG_WARN("The update framerate should not be less than the draw framerate, this may slow down the game.");
            }

            Engine::GetInstance()->Apply(cpuLimiterEnabled, updateFPS, drawFPS, timeScale);
        }
        DEFINE_PRIME4v(spoopy_engine_apply);

        void spoopy_engine_run_raw() {
            Engine::GetInstance()->Run();
        }
        DEFINE_PRIME0v(spoopy_engine_run_raw);
    }
}}