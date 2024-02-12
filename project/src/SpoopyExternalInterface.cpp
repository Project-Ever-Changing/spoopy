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
#include "graphics/vulkan/components/CommandPoolVulkan.h"
#include "graphics/vulkan/CommandBufferVulkan.h"
#include "graphics/vulkan/QueueVulkan.h"
#include "graphics/vulkan/EntryVulkan.h"


typedef lime::spoopy::GraphicsVulkan GraphicsModule;
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
        Context &context = sdlWindow->context;

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

        PhysicalDevice &physicalDevice = *GraphicsModule::GetCurrent()->GetPhysicalDevice();
        context->InitSwapchain(width, height, sdlWindow->sdlWindow, physicalDevice);
        context->coreRecreateSwapchain = new ValuePointer(callback);
    }
    DEFINE_PRIME2v(spoopy_device_init_swapchain);

    void spoopy_device_create_swapchain(value window_handle) {
        Window* window = (Window*)val_data(window_handle);
        SDLWindow* sdlWindow = static_cast<SDLWindow*>(window);
        Context &context = sdlWindow->context;

        context->CreateSwapchain(sdlWindow->sdlWindow);
    }
    DEFINE_PRIME1v(spoopy_device_create_swapchain);

    void spoopy_device_destroy_swapchain(value window_handle) {
        Window* window = (Window*)val_data(window_handle);
        SDLWindow* sdlWindow = static_cast<SDLWindow*>(window);
        Context &context = sdlWindow->context;

        if(!context->GetSwapchain()) {
            SPOOPY_LOG_ERROR("Attempted to destroy a swapchain that doesn't exist!");
            return;
        }

        context->DestroySwapchain();
    }
    DEFINE_PRIME1v(spoopy_device_destroy_swapchain);

    void spoopy_device_recreate_swapchain(value window_handle) {
        Window* window = (Window*)val_data(window_handle);
        SDLWindow* sdlWindow = static_cast<SDLWindow*>(window);
        Context &context = sdlWindow->context;

        int32 width, height;
        GetDrawableSize(sdlWindow->sdlWindow, &width, &height);
        context->RecreateSwapchainWrapper(width, height);
    }
    DEFINE_PRIME1v(spoopy_device_recreate_swapchain);

    int spoopy_device_get_swapchain_image_count(value window_handle) {
        Window* window = (Window*)val_data(window_handle);
        SDLWindow* sdlWindow = static_cast<SDLWindow*>(window);
        Context &context = sdlWindow->context;

        return (int)context->GetSwapchain()->GetImageCount();
    }
    DEFINE_PRIME1(spoopy_device_get_swapchain_image_count);

    void spoopy_device_set_swapchain_size(value window_handle, int width, int height) {
        Window* window = (Window*)val_data(window_handle);
        SDLWindow* sdlWindow = static_cast<SDLWindow*>(window);
        Context &context = sdlWindow->context;

        context->GetSwapchain()->SetSize(width, height);
    }
    DEFINE_PRIME3v(spoopy_device_set_swapchain_size);

    void spoopy_check_context(value window_handle) {
        Window* window = (Window*)val_data(window_handle);
        SDLWindow* sdlWindow = static_cast<SDLWindow*>(window);
        Context &context = sdlWindow->context;

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
        Context &context = sdlWindow->context;
        context->stage = std::make_unique<ContextStage>(*context, Viewport(viewport));
    }
    DEFINE_PRIME2v(spoopy_create_context_stage);


    // Objects

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
        Context &context = sdlWindow->context;

        CommandPool* _commandPool = new CommandPool(*GraphicsModule::GetCurrent()->GetLogicalDevice(), context->GetQueue()->GetFamilyIndex());
        return CFFIPointer(_commandPool, spoopy_gc_command_pool);
    }
    DEFINE_PRIME1(spoopy_create_command_pool);

    value spoopy_create_command_buffer(value command_pool, bool begin) {
        CommandPool* _commandPool = (CommandPool*)val_data(command_pool);
        CommandBuffer* _commandBuffer = new CommandBuffer(
            *GraphicsModule::GetCurrent()->GetLogicalDevice(),
            _commandPool,
            begin
        );

        return CFFIPointer(_commandBuffer, spoopy_gc_command_buffer);
    }
    DEFINE_PRIME2(spoopy_create_command_buffer);

    void spoopy_command_buffer_begin_record(value command_buffer) {
        CommandBuffer* _commandBuffer = (CommandBuffer*)val_data(command_buffer);
        _commandBuffer->BeginRecord();
    }
    DEFINE_PRIME1v(spoopy_command_buffer_begin_record);

    void spoopy_command_buffer_end_render_pass(value command_buffer) {
        CommandBuffer* _commandBuffer = (CommandBuffer*)val_data(command_buffer);
        _commandBuffer->EndRenderPass();
    }
    DEFINE_PRIME1v(spoopy_command_buffer_end_render_pass);

    void spoopy_command_buffer_end_record(value command_buffer) {
        CommandBuffer* _command_buffer = (CommandBuffer*)val_data(command_buffer);
        _command_buffer->EndRecord();
    }
    DEFINE_PRIME1v(spoopy_command_buffer_end_record);

    void spoopy_command_buffer_free(value command_buffer) {
        CommandBuffer* _commandBuffer = (CommandBuffer*)val_data(command_buffer);
        _commandBuffer->Free();
    }
    DEFINE_PRIME1v(spoopy_command_buffer_free);

    void spoopy_command_buffer_reset(value command_buffer) {
        CommandBuffer* _commandBuffer = (CommandBuffer*)val_data(command_buffer);
        _commandBuffer->Reset();
    }
    DEFINE_PRIME1v(spoopy_command_buffer_reset);

    value spoopy_create_entry(value window_handle) {
        Window* window = (Window*)val_data(window_handle);
        SDLWindow* sdlWindow = static_cast<SDLWindow*>(window);
        Context &context = sdlWindow->context;

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
        void spoopy_engine_bind_callbacks(value updateCallback, value drawCallback, value syncGC) {
            if (!val_is_function(updateCallback)) {
                SPOOPY_LOG_ERROR("Update callback is not a function!");
                return;
            }

            if (!val_is_function(drawCallback)) {
                SPOOPY_LOG_ERROR("Draw callback is not a function!");
                return;
            }

	    if (!val_is_function(syncGC)) {
		SPOOPY_LOG_ERROR("SyncGC callback is not a function!");
		return;
	    }

            Engine::GetInstance()->BindCallbacks(updateCallback, drawCallback, syncGC);
        }
        DEFINE_PRIME3v(spoopy_engine_bind_callbacks);

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

        void spoopy_engine_shutdown() {
            Engine::GetInstance()->RequestExit();
        }
        DEFINE_PRIME0v(spoopy_engine_shutdown);
    }
}}
