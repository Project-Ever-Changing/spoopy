/*
 * Precisely as the file name suggests, this cpp file contains objects that
 * aren't affiliated with Haxe's garbage collector. These classes are mainly
 * low-level wrapped objects tailored to Vulkan and, in the future, DirectX-12.
 */

#include <system/CFFI.h>
#include <system/CFFIPointer.h>
#include <utils/MemoryReader.h>
#include <core/Log.h>
#include <graphics/Enums.h>
#include <SDLWindow.h>
#include <spoopy_byte.h>
#include <spoopy.h>

#ifdef SPOOPY_VULKAN

#include "../graphics/vulkan/GraphicsVulkan.h"
#include "../graphics/vulkan/components/SemaphoreVulkan.h"
#include "../graphics/vulkan/PipelineVulkan.h"
#include "../graphics/vulkan/RenderPassVulkan.h"
#include "../graphics/vulkan/components/FenceVulkan.h"
#include "../graphics/vulkan/CommandBufferVulkan.h"
#include "../graphics/vulkan/QueueVulkan.h"

typedef lime::spoopy::SemaphoreVulkan GPUSemaphore;
typedef lime::spoopy::GraphicsVulkan GraphicsModule;
typedef lime::spoopy::PipelineVulkan Pipeline;
typedef lime::spoopy::FenceVulkan GPUFence;
typedef lime::spoopy::CommandBufferVulkan GPUCommandBuffer;
typedef lime::spoopy::RenderPassVulkan RenderPass;

#endif

namespace lime { namespace spoopy {
    /*
     * Delete Wrapper
     */
    void spoopy_delete_semaphore(value semaphore) {
        GPUSemaphore* _semaphore = (GPUSemaphore*)val_data(semaphore);
        delete _semaphore;
    }

    void spoopy_delete_pipeline(value pipeline) {
        Pipeline* _pipeline = (Pipeline*)val_data(pipeline);
        delete _pipeline;
    }

    void spoopy_delete_gpu_fence(value fence) {
        GPUFence* _fence = (GPUFence*)val_data(fence);
        delete _fence;
    }

    void spoopy_gc_render_pass(value handle) {
        RenderPass* _renderPass = (RenderPass*)val_data(handle);
        delete _renderPass;
    }


    value spoopy_create_semaphore() {
        GPUSemaphore* _semaphore = new GPUSemaphore(*GraphicsModule::GetCurrent()->GetLogicalDevice());
        return CFFIPointer(_semaphore, spoopy_delete_semaphore);
    }
    DEFINE_PRIME0(spoopy_create_semaphore);

    void spoopy_recreate_semaphore(value semaphore) {
        GPUSemaphore* _semaphore = (GPUSemaphore*)val_data(semaphore);
        _semaphore->Create();
    }
    DEFINE_PRIME1v(spoopy_recreate_semaphore);

    value spoopy_create_pipeline() {
        Pipeline *_pipeline = new Pipeline(*GraphicsModule::GetCurrent()->GetLogicalDevice());
        return CFFIPointer(_pipeline, spoopy_delete_pipeline);
    }
    DEFINE_PRIME0(spoopy_create_pipeline);

    value spoopy_create_gpu_fence(bool signaled) {
        GPUFence* _fence = new GPUFence(*GraphicsModule::GetCurrent()->GetLogicalDevice(), signaled);
        return CFFIPointer(_fence, spoopy_delete_gpu_fence);
    }
    DEFINE_PRIME1(spoopy_create_gpu_fence);

    value spoopy_create_render_pass(int msaaLevel, value window_handle) {
        Window* window = (Window*)val_data(window_handle);
        SDLWindow* sdlWindow = static_cast<SDLWindow*>(window);
        Context &context = sdlWindow->context;
        
        RenderPass* _renderPass = new RenderPass(
            *GraphicsModule::GetCurrent()->GetLogicalDevice()
            , context->GetSwapchain()->GetFormat()
            , msaaLevel
        );

        return CFFIPointer(_renderPass, spoopy_gc_render_pass);
    }
    DEFINE_PRIME2(spoopy_create_render_pass);

    void spoopy_recreate_render_pass(value renderPass) {
        RenderPass* _renderPass = (RenderPass*)val_data(renderPass);
        _renderPass->Create();
    }
    DEFINE_PRIME1v(spoopy_recreate_render_pass);


    void spoopy_set_gpu_fence_signal(value fence, bool signaled) {
        GPUFence* _fence = (GPUFence*)val_data(fence);
        _fence->SetSignaled(signaled);
    }
    DEFINE_PRIME2v(spoopy_set_gpu_fence_signal);


    #ifdef LIME_NEKO

    bool spoopy_wait_gpu_fence(value fence, value val_nanoseconds) {
        GPUFence* _fence = (GPUFence*)val_data(fence);

        std::byte* bytes = (std::byte*)val_data(val_nanoseconds);
        uint32_t low = *((uint32_t*)(bytes + 0));
        uint32_t high = *((uint32_t*)(bytes + 4));

        // Combine the high and low parts into a uint64_t
        // We need to make room for the low bits
        uint64_t nanoseconds = ((uint64_t)high << 32) | low;
        return _fence->Wait(nanoseconds);
    }
    DEFINE_PRIME2(spoopy_wait_gpu_fence);

    #else

    bool spoopy_wait_gpu_fence(value fence, value val_nanoseconds) {
        GPUFence* _fence = (GPUFence*)val_data(fence);
        uint64_t nanoseconds = *(uint64_t*)val_data(val_nanoseconds);
        SPOOPY_LOG_INFO(LOG_TYPE::FORMATTED, "Waiting for fence for %llu nanoseconds: ", nanoseconds);
        return _fence->Wait(nanoseconds);
    }
    DEFINE_PRIME2(spoopy_wait_gpu_fence);

    #endif


    void spoopy_reset_gpu_fence(value fence) {
        GPUFence* _fence = (GPUFence*)val_data(fence);
        _fence->Reset();
    }
    DEFINE_PRIME1v(spoopy_reset_gpu_fence);

    int spoopy_device_acquire_next_image(value window_handle, value imageAvailableSemaphore
    , value fence_handle, int prevSemaphoreIndex, int semaphoreIndex) {
        Window* window = (Window*)val_data(window_handle);
        SDLWindow* sdlWindow = static_cast<SDLWindow*>(window);
        Context &context = sdlWindow->context;

        return (int)context->GetSwapchain()->AcquireNextImage(
            imageAvailableSemaphore,
            (GPUFence*)val_data(fence_handle),
            prevSemaphoreIndex,
            semaphoreIndex
        );
    }
    DEFINE_PRIME5(spoopy_device_acquire_next_image);

    int spoopy_device_present_image(value window_handle, value semaphore) {
        Window* window = (Window*)val_data(window_handle);
        SDLWindow* sdlWindow = static_cast<SDLWindow*>(window);
        Context &context = sdlWindow->context;

        GPUSemaphore* _semaphore = (GPUSemaphore*)val_data(semaphore);
        return context->PresentImageSwapchain(GraphicsModule::GetCurrent()->GetLogicalDevice()->GetPresentQueue(), _semaphore);
    }
    DEFINE_PRIME2(spoopy_device_present_image);

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

    int spoopy_queue_submit(value cmd_buffer, value fence, value rawWaitSemaphores, int state, value signalSemaphore) {
        GPUFence* _fence = (GPUFence*)val_data(fence);
        GPUSemaphore* _signalSemaphore = nullptr;
        GPUCommandBuffer* _cmd_buffer = (GPUCommandBuffer*)val_data(cmd_buffer);

        if(!val_is_null(signalSemaphore)) {
            _signalSemaphore = (GPUSemaphore*)val_data(signalSemaphore);
        }

        return GraphicsModule::GetCurrent()->GetLogicalDevice()->GetGraphicsQueue()->Submit(
            _cmd_buffer,
            _fence,
            rawWaitSemaphores,
            state,
            *_signalSemaphore
        );
    }
    DEFINE_PRIME5(spoopy_queue_submit);

    void spoopy_dealloc_gpu_cffi_pointer(int type, value pointer) { // Pure Deallocator for raw references
        switch((BackendType)type) {
            #define SAFE_CASE(x) case BackendType::x: { x* buffer = (x*)val_data(pointer); buffer->Destroy(); break; }

            SAFE_CASE(GPUSemaphore);
            SAFE_CASE(Pipeline);
            SAFE_CASE(GPUFence);

            default:
                SPOOPY_LOG_ERROR("Invalid CFFIPointer type!");
                break;

            #undef SAFE_CASE
        }
    }
    DEFINE_PRIME2v(spoopy_dealloc_gpu_cffi_pointer);
}}