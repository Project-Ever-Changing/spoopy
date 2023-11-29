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
#include <spoopy.h>

#ifdef SPOOPY_VULKAN

#include "../graphics/vulkan/GraphicsVulkan.h"
#include "../graphics/vulkan/components/SemaphoreVulkan.h"
#include "../graphics/vulkan/PipelineVulkan.h"

typedef lime::spoopy::SemaphoreVulkan Semaphore;
typedef lime::spoopy::GraphicsVulkan GraphicsModule;
typedef lime::spoopy::PipelineVulkan Pipeline;

#endif

namespace lime { namespace spoopy {
    value spoopy_create_semaphore() {
        Semaphore* _semaphore = new Semaphore(*GraphicsModule::GetCurrent()->GetLogicalDevice());
        return CFFIPointer(_semaphore, nullptr);
    }
    DEFINE_PRIME0(spoopy_create_semaphore);

    value spoopy_create_pipeline() {
        Pipeline *_pipeline = new Pipeline(*GraphicsModule::GetCurrent()->GetLogicalDevice());
        return CFFIPointer(_pipeline, nullptr);
    }
    DEFINE_PRIME0(spoopy_create_pipeline);

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
            #define CASE(x) case BackendType::x: { x* buffer = (x*)val_data(pointer); delete buffer; break; }

            CASE(Semaphore);
            CASE(Pipeline);

            default:
                SPOOPY_LOG_ERROR("Invalid CFFIPointer type!");
                break;

            #undef CASE
        }
    }
    DEFINE_PRIME2v(spoopy_dealloc_gpu_cffi_pointer);
}}