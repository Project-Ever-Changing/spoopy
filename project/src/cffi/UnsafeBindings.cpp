/*
 * Precisely as the file name suggests, this cpp file contains objects that
 * aren't affiliated with Haxe's garbage collector. These classes are mainly
 * low-level wrapped objects tailored to Vulkan and, in the future, DirectX-12.
 * I can't trust the Haxe garbage compiler to deallocate these objects
 * since they are significant in GPU rendering.
 *
 * NOTE: Haxe Garbage Collector does not affect these objects, but it does delete Haxe's CFFIPointer.
 */

#include <system/CFFI.h>
#include <system/CFFIPointer.h>
#include <utils/MemoryReader.h>
#include <core/Log.h>
#include <graphics/Enums.h>
#include <SDLWindow.h>
#include <spoopy.h>

#ifdef SPOOPY_VULKAN

#include "../graphics/vulkan/GraphicsVulkan.h"
#include "../graphics/vulkan/components/SemaphoreVulkan.h"
#include "../graphics/vulkan/PipelineVulkan.h"
#include "../graphics/vulkan/components/FenceVulkan.h"

typedef lime::spoopy::SemaphoreVulkan GPUSemaphore;
typedef lime::spoopy::GraphicsVulkan GraphicsModule;
typedef lime::spoopy::PipelineVulkan Pipeline;
typedef lime::spoopy::FenceVulkan GPUFence;

#endif

namespace lime { namespace spoopy {
    value spoopy_create_semaphore() {
        GPUSemaphore* _semaphore = new GPUSemaphore(*GraphicsModule::GetCurrent()->GetLogicalDevice());
        return CFFIPointer(_semaphore, nullptr);
    }
    DEFINE_PRIME0(spoopy_create_semaphore);

    value spoopy_create_pipeline() {
        Pipeline *_pipeline = new Pipeline(*GraphicsModule::GetCurrent()->GetLogicalDevice());
        return CFFIPointer(_pipeline, nullptr);
    }
    DEFINE_PRIME0(spoopy_create_pipeline);

    value spoopy_create_gpu_fence(bool signaled) {
        GPUFence* _fence = new GPUFence(*GraphicsModule::GetCurrent()->GetLogicalDevice(), signaled);
        return CFFIPointer(_fence, nullptr);
    }
    DEFINE_PRIME1(spoopy_create_gpu_fence);

    void spoopy_set_gpu_fence_signal(value fence, bool signaled) {
        GPUFence* _fence = (GPUFence*)val_data(fence);
        _fence->SetSignaled(true);
    }
    DEFINE_PRIME2v(spoopy_set_gpu_fence_signal);

    bool spoopy_wait_gpu_fence(value fence, int nanoseconds) {
        GPUFence* _fence = (GPUFence*)val_data(fence);
        return _fence->Wait((uint64_t)nanoseconds);
    }
    DEFINE_PRIME2(spoopy_wait_gpu_fence);

    void spoopy_reset_gpu_fence(value fence) {
        GPUFence* _fence = (GPUFence*)val_data(fence);
        _fence->Reset();
    }
    DEFINE_PRIME1v(spoopy_reset_gpu_fence);

    int spoopy_device_acquire_next_image(value window_handle, value imageAvailableSemaphore
    , value fence_handle, int prevSemaphoreIndex, int semaphoreIndex) {
        Window* window = (Window*)val_data(window_handle);
        SDLWindow* sdlWindow = static_cast<SDLWindow*>(window);
        Context context = sdlWindow->context;

        return (int)context->GetSwapchain()->AcquireNextImage(
            imageAvailableSemaphore,
            (GPUFence*)val_data(fence_handle),
            prevSemaphoreIndex,
            semaphoreIndex
        );
    }
    DEFINE_PRIME5(spoopy_device_acquire_next_image);

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

    void spoopy_dealloc_gpu_cffi_pointer(int type, value pointer) { // Pure CFFIPointer Deallocator
        switch((BackendType)type) {
            #define SAFE_CASE(x) case BackendType::x: { x* buffer = (x*)val_data(pointer); delete buffer; buffer = nullptr; break; }

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