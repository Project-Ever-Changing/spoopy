#include <iostream>
#include <string>
#include <cstdlib>

#include <helpers/SpoopyBufferHelper.h>
#include <system/CFFIPointer.h>
#include <core/Log.h>

#ifdef SPOOPY_VULKAN
#include <device/InstanceDevice.h>
#include <device/LogicalDevice.h>
#include <device/PhysicalDevice.h>
#include <device/SurfaceDevice.h>
#endif

#if defined(SPOOPY_VULKAN) || defined(SPOOPY_METAL)
#include <ui/SpoopyWindowRenderer.h>
#include <shaders/Shader.h>
#include <graphics/Buffer.h>
#endif

#ifdef SPOOPY_INCLUDE_EXAMPLE
#include <examples/ExampleWindow.h>
#endif

#include <shaders/CrossShader.h>

namespace lime {
#ifdef SPOOPY_VULKAN

    void apply_gc_instance_device(value handle) {
        InstanceDevice* instanceDevice = (InstanceDevice*)val_data(handle);
        delete instanceDevice;
    }

    void apply_gc_physical_device(value handle) {
        PhysicalDevice* physicalDevice = (PhysicalDevice*)val_data(handle);
        delete physicalDevice;
    }

    void apply_gc_logical_device(value handle) {
        LogicalDevice* logicalDevice = (LogicalDevice*)val_data(handle);
        delete logicalDevice;
    }

    void apply_gc_surface(value handle) {
        SurfaceDevice* surface = (SurfaceDevice*)val_data(handle);
        delete surface;
    }

    value spoopy_create_instance_device(value window, HxString name, int major, int minor, int patch) {
        const int version[3] = {major, minor, patch};

        SpoopyWindowRenderer* targetWindowSurface = (SpoopyWindowRenderer*)val_data(window);

        InstanceDevice* instanceDevice = new InstanceDevice(*targetWindowSurface);
        instanceDevice -> createInstance(name.c_str(), version);
        instanceDevice -> createDebugMessenger();

        return CFFIPointer(instanceDevice, apply_gc_instance_device);
    }
    DEFINE_PRIME5(spoopy_create_instance_device);

    value spoopy_create_physical_device(value instance) {
        InstanceDevice* cast_Instance = (InstanceDevice*)val_data(instance);

        PhysicalDevice* physical = new PhysicalDevice(*cast_Instance);
        return CFFIPointer(physical, apply_gc_physical_device);
    }
    DEFINE_PRIME1(spoopy_create_physical_device);

    value spoopy_create_logical_device(value instance, value physical) {
        InstanceDevice* cast_Instance = (InstanceDevice*)val_data(instance);
        PhysicalDevice* cast_Physical = (PhysicalDevice*)val_data(physical);

        LogicalDevice* logical = new LogicalDevice(*cast_Instance, *cast_Physical);
        logical -> initDevice();

        return CFFIPointer(logical, apply_gc_logical_device);
    }
    DEFINE_PRIME2(spoopy_create_logical_device);

    value spoopy_create_surface(value instance_handle, value physical_handle, value logical_handle, value window_handle) {
        InstanceDevice* instance = (InstanceDevice*)val_data(instance_handle);
        PhysicalDevice* physical = (PhysicalDevice*)val_data(physical_handle);
        LogicalDevice* logical = (LogicalDevice*)val_data(logical_handle);
        SpoopyWindowRenderer* window = (SpoopyWindowRenderer*)val_data(window_handle);

        SurfaceDevice* surface = new SurfaceDevice(*instance, *physical, *logical, *window);
        return CFFIPointer(surface, apply_gc_surface);
    }
    DEFINE_PRIME4(spoopy_create_surface);

#endif

#ifdef SPOOPY_METAL

    void spoopy_assign_metal_surface(value window_surface, value metal_device) {
        SpoopyWindowRenderer* windowSurface = (SpoopyWindowRenderer*)val_data(window_surface);
        windowSurface -> assignMetalDevice(metal_device);
    }
    DEFINE_PRIME2v(spoopy_assign_metal_surface);

    void spoopy_surface_set_vertex_buffer(value window_surface, value buffer, int offset, int atIndex) {
        SpoopyWindowRenderer* windowSurface = (SpoopyWindowRenderer*)val_data(window_surface);
        windowSurface -> setVertexBuffer(buffer, offset, atIndex);
    }
    DEFINE_PRIME4v(spoopy_surface_set_vertex_buffer);

    value spoopy_spv_to_metal_shader(HxString shader) {
        std::string mtlshader = lime::compile(shader.c_str(), ShaderFormat::MSL);

        char* result = new char[mtlshader.size() + 1];
        strcpy(result, mtlshader.c_str());

        if(result) {
            value _mtlshader = alloc_string(result);
            free(result);
            return _mtlshader;
        }else {
            return alloc_null();
        }
    }
    DEFINE_PRIME1(spoopy_spv_to_metal_shader);

#endif

#if defined(SPOOPY_VULKAN) || defined(SPOOPY_METAL)

    void apply_gc_window_surface(value handle) {
        SpoopyWindowRenderer* windowSurface = (SpoopyWindowRenderer*)val_data(handle);
        delete windowSurface;
    }

    void apply_gc_shader(value handle) {
        Shader* shader = (Shader*)val_data(handle);
        delete shader;
    }

    void apply_gc_buffer(value handle) {
        Buffer* buffer = (Buffer*)val_data(handle);
        delete buffer;
    }

    value spoopy_create_window_surface(value window_handle) {
        SDLWindow* window = (SDLWindow*)val_data(window_handle);

        SpoopyWindowRenderer* windowSurface = createWindowRenderer(*window);
        return CFFIPointer(windowSurface, apply_gc_window_surface);
    }
    DEFINE_PRIME1(spoopy_create_window_surface);

    void spoopy_update_window_surface(value window_surface) {
        SpoopyWindowRenderer* windowSurface = (SpoopyWindowRenderer*)val_data(window_surface);
        windowSurface -> render();
    }
    DEFINE_PRIME1v(spoopy_update_window_surface);

    void spoopy_release_window_surface(value window_surface) {
        SpoopyWindowRenderer* windowSurface = (SpoopyWindowRenderer*)val_data(window_surface);
        windowSurface -> clear();
    }
    DEFINE_PRIME1v(spoopy_release_window_surface);

    void spoopy_set_surface_cull_face(value window_surface, int cullMode) {
        SpoopyWindowRenderer* windowSurface = (SpoopyWindowRenderer*)val_data(window_surface);
        windowSurface -> cullFace(cullMode);
    }
    DEFINE_PRIME2v(spoopy_set_surface_cull_face);

    void spoopy_set_vertex_buffer(value window_surface, value buffer, int offset, int atIndex) {
        SpoopyWindowRenderer* windowSurface = (SpoopyWindowRenderer*)val_data(window_surface);
        windowSurface -> setVertexBuffer(buffer, offset, atIndex);
    }
    DEFINE_PRIME4v(spoopy_set_vertex_buffer);

    value spoopy_create_shader(value window_surface, value device) {
        Shader* shader = createShader(window_surface, device);
        return CFFIPointer(shader, apply_gc_shader);
    }
    DEFINE_PRIME2(spoopy_create_shader);

    value spoopy_create_shader_pipeline(value _shader) {
        Shader* shader = (Shader*)val_data(_shader);
        return shader -> createShaderPipeline();
    }
    DEFINE_PRIME1(spoopy_create_shader_pipeline);

    void spoopy_specialize_shader(value _shader, HxString _name, HxString _vertex, HxString _fragment) {
        Shader* shader = (Shader*)val_data(_shader);
        shader -> specializeShader(_name.c_str(), _vertex.c_str(), _fragment.c_str());
    }
    DEFINE_PRIME4v(spoopy_specialize_shader);

    void spoopy_cleanup_shader(value _shader) {
        Shader* shader = (Shader*)val_data(_shader);
        shader -> cleanUp();
    }
    DEFINE_PRIME1v(spoopy_cleanup_shader);

    void spoopy_bind_shader(value window_surface, value pipeline) {
        SpoopyWindowRenderer* windowSurface = (SpoopyWindowRenderer*)val_data(window_surface);
        windowSurface -> useProgram(pipeline);
    }
    DEFINE_PRIME2v(spoopy_bind_shader);

    value spoopy_create_buffer(value device, int size, int bucketSize, int type, int usage) {
        Buffer* buffer = createBuffer(device, size, bucketSize, type, usage);
        return CFFIPointer(buffer, apply_gc_buffer);
    }
    DEFINE_PRIME5(spoopy_create_buffer);

    int spoopy_get_buffer_length_bytes(value buffer_handle) {
        Buffer* buffer = (Buffer*)val_data(buffer_handle);
        return (int)buffer -> getSize();
    }
    DEFINE_PRIME1(spoopy_get_buffer_length_bytes);

    void spoopy_update_buffer_data(value buffer_handle, double data, int size) {
        Buffer* buffer = (Buffer*)val_data(buffer_handle);
        buffer -> updateData((void*)(uintptr_t)data, (std::size_t)size);
    }
    DEFINE_PRIME3v(spoopy_update_buffer_data);

    void spoopy_update_buffer_sub_data(value buffer_handle, double data, int offset, int size) {
        Buffer* buffer = (Buffer*)val_data(buffer_handle);
        buffer -> updateSubData((void*)(uintptr_t)data, (std::size_t)offset, (std::size_t)size);
    }
    DEFINE_PRIME4v(spoopy_update_buffer_sub_data);

    void spoopy_buffer_begin_frame(value buffer_handle) {
        Buffer* buffer = (Buffer*)val_data(buffer_handle);
        buffer -> beginFrame();
    }
    DEFINE_PRIME1v(spoopy_buffer_begin_frame);

    void spoopy_set_shader_uniform(value _shader, value uniform_handle, int offset, int loc, double val, int numRegs) {
        Shader* shader = (Shader*)val_data(_shader);

#ifdef SPOOPY_METAL
        shader -> setShaderUniform(uniform_handle, offset, loc, (void*)(uintptr_t)val, numRegs);
#endif
    }
    DEFINE_PRIME6v(spoopy_set_shader_uniform);

#endif

#ifdef SPOOPY_INCLUDE_EXAMPLE

    void apply_gc_example_window(value handle) {
        ExampleWindow* window = (ExampleWindow*)val_data(handle);
        delete window;
    }

    value spoopy_create_example_window(HxString title, int width, int height, int flags) {
        ExampleWindow* window = new ExampleWindow(title.c_str(), width, height, flags);
        return CFFIPointer(window, apply_gc_example_window);
    }
    DEFINE_PRIME4(spoopy_create_example_window);

#endif

    //Testing Purposes

    bool has_spoopy_wrapper() {
        return true;
    }
    DEFINE_PRIME0(has_spoopy_wrapper);
}