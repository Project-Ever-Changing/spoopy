#include <iostream>
#include <string>
#include <cstdlib>

#include <graphics/Texture.h>
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

    void spoopy_assign_metal_surface(value window_surface) {
        SpoopyWindowRenderer* windowSurface = (SpoopyWindowRenderer*)val_data(window_surface);
        windowSurface -> assignMetalDevice();
    }
    DEFINE_PRIME1v(spoopy_assign_metal_surface);

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

    void apply_gc_texture_descriptor(value handle) {
        TextureDescriptor* descriptor = (TextureDescriptor*)val_data(handle);
        delete descriptor;
    }

    void apply_gc_texture(value handle) {
        Texture2D* texture = (Texture2D*)val_data(handle);
        delete texture;
    }

    value spoopy_create_texture_descriptor(int width, int height, int type, int format, int usage, value sd) {
        TextureDescriptor* descriptor = new TextureDescriptor();
        SamplerDescriptor sampler(sd);

        descriptor -> width = width;
        descriptor -> height = height;
        descriptor -> textureType = (TextureType)type;

        PixelFormat _format = (PixelFormat)format;
        SDL_PixelFormatEnum pixelFormat;

        switch(_format) {
            case ARGB32:
                pixelFormat = SDL_PIXELFORMAT_ARGB8888;
                break;
            case BGRA32:
                pixelFormat = SDL_PIXELFORMAT_BGRA8888;
                break;
            default:
                pixelFormat = SDL_PIXELFORMAT_RGBA8888;
                break;
        }

        descriptor -> textureFormat = pixelFormat;
        descriptor -> textureUsage = (TextureUsage)usage;
        descriptor -> samplerDescriptor = sampler;

        return CFFIPointer(descriptor, apply_gc_texture_descriptor);
    }
    DEFINE_PRIME6(spoopy_create_texture_descriptor);

    void spoopy_update_texture_descriptor(value texture, value td, int width, int height, int type, int format, int usage, value sd) {
        Texture* _texture = (Texture*)val_data(texture);
        TextureDescriptor* descriptor = (TextureDescriptor*)val_data(td);
        SamplerDescriptor sampler(sd);

        descriptor -> width = width;
        descriptor -> height = height;
        descriptor -> textureType = (TextureType)type;

        PixelFormat _format = (PixelFormat)format;
        SDL_PixelFormatEnum pixelFormat;

        switch(_format) {
            case ARGB32:
                pixelFormat = SDL_PIXELFORMAT_ARGB8888;
                break;
            case BGRA32:
                pixelFormat = SDL_PIXELFORMAT_BGRA8888;
                break;
            default:
                pixelFormat = SDL_PIXELFORMAT_RGBA8888;
                break;
        }

        descriptor -> textureFormat = pixelFormat;
        descriptor -> textureUsage = (TextureUsage)usage;
        descriptor -> samplerDescriptor = sampler;

        _texture -> updateTextureDescriptor(*descriptor);
    }
    DEFINE_PRIME8v(spoopy_update_texture_descriptor);

    void spoopy_update_sampler_descriptor(value texture, value sd) {
        Texture* _texture = (Texture*)val_data(texture);
        SamplerDescriptor sampler(sd);
        _texture -> updateSamplerDescriptor(sampler);
    }
    DEFINE_PRIME2v(spoopy_update_sampler_descriptor);

    value spoopy_create_texture(value device, value descriptor) {
        TextureDescriptor* _descriptor = (TextureDescriptor*)val_data(descriptor);
        Texture2D* texture = createTexture2D(device, *_descriptor);
        return CFFIPointer(texture, apply_gc_texture);
    }
    DEFINE_PRIME2(spoopy_create_texture);

    value spoopy_create_window_surface(value window_handle) {
        Window* window = (Window*)val_data(window_handle);
        SDLWindow* sdlWindow = static_cast<SDLWindow*>(window);

        if(sdlWindow -> sdlRenderer == NULL) {
            printf("Error creating renderer: %s\n", SDL_GetError());
        }

        SpoopyWindowRenderer* windowSurface = createWindowRenderer(*sdlWindow);
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

    void spoopy_set_surface_winding(value window_surface, int winding) {
        SpoopyWindowRenderer* windowSurface = (SpoopyWindowRenderer*)val_data(window_surface);
        windowSurface -> setWinding(winding);
    }
    DEFINE_PRIME2v(spoopy_set_surface_winding);

    void spoopy_set_surface_viewport(value window_surface, value rect) {
        SpoopyWindowRenderer* windowSurface = (SpoopyWindowRenderer*)val_data(window_surface);

        if(!val_is_null(rect)) {
            Rectangle rectangle = Rectangle(rect);
            windowSurface -> setViewport(&rectangle);
        }
    }
    DEFINE_PRIME2v(spoopy_set_surface_viewport);

    void spoopy_set_surface_scissor_rect(value window_surface, value rect, bool enabled) {
        SpoopyWindowRenderer* windowSurface = (SpoopyWindowRenderer*)val_data(window_surface);

        if(!val_is_null(rect)) {
            Rectangle rectangle = Rectangle(rect);
            windowSurface -> setScissorMode(enabled, &rectangle);
        }
    }
    DEFINE_PRIME3v(spoopy_set_surface_scissor_rect);

    void spoopy_set_surface_line_width(value window_surface, float width) {
        SpoopyWindowRenderer* windowSurface = (SpoopyWindowRenderer*)val_data(window_surface);
        windowSurface -> setLineWidth(width);
    }
    DEFINE_PRIME2v(spoopy_set_surface_line_width);

    void spoopy_set_surface_render_target(value window_surface, int flags, value ct, value dt, value st) {
        SpoopyWindowRenderer* windowSurface = (SpoopyWindowRenderer*)val_data(window_surface);

        Texture2D* colorTexture;
        Texture2D* depthTexture;
        Texture2D* stencilTexture;

        if(!val_is_null(ct)) {
            colorTexture = (Texture2D*)val_data(ct);
        }

        if(!val_is_null(dt)) {
            depthTexture = (Texture2D*)val_data(dt);
        }

        if(!val_is_null(st)) {
            stencilTexture = (Texture2D*)val_data(st);
        }

        windowSurface -> setRenderTarget((RenderTargetFlag)flags, colorTexture, depthTexture, stencilTexture);
    }
    DEFINE_PRIME5v(spoopy_set_surface_render_target);

    void spoopy_surface_begin_render_pass(value window_surface) {
        SpoopyWindowRenderer* windowSurface = (SpoopyWindowRenderer*)val_data(window_surface);
        windowSurface -> beginRenderPass();
    }
    DEFINE_PRIME1v(spoopy_surface_begin_render_pass);

    void spoopy_surface_draw_arrays(value window_surface, int primitiveType, int start, int count) {
        SpoopyWindowRenderer* windowSurface = (SpoopyWindowRenderer*)val_data(window_surface);
        windowSurface -> drawArrays(primitiveType, (size_t)start, (size_t)count);
    }
    DEFINE_PRIME4v(spoopy_surface_draw_arrays);

    void spoopy_surface_draw_elements(value window_surface, int primitiveType, int indexFormat, int count, int offset) {
        SpoopyWindowRenderer* windowSurface = (SpoopyWindowRenderer*)val_data(window_surface);
        windowSurface -> drawElements(primitiveType, indexFormat, (size_t)count, (size_t)offset);
    }
    DEFINE_PRIME5v(spoopy_surface_draw_elements);

    bool spoopy_surface_find_command_buffer(value window_surface) {
        SpoopyWindowRenderer* windowSurface = (SpoopyWindowRenderer*)val_data(window_surface);
        return windowSurface -> findCommandBuffer();
    }
    DEFINE_PRIME1(spoopy_surface_find_command_buffer);

    void spoopy_set_vertex_buffer(value window_surface, value buffer, int offset, int atIndex) {
        SpoopyWindowRenderer* windowSurface = (SpoopyWindowRenderer*)val_data(window_surface);
        windowSurface -> setVertexBuffer(buffer, offset, atIndex);
    }
    DEFINE_PRIME4v(spoopy_set_vertex_buffer);

    void spoopy_set_index_buffer(value window_surface, value buffer) {
        SpoopyWindowRenderer* windowSurface = (SpoopyWindowRenderer*)val_data(window_surface);
        windowSurface -> setIndexBuffer(buffer);
    }
    DEFINE_PRIME2v(spoopy_set_index_buffer);

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

    // Testing Purposes

    bool has_spoopy_wrapper() {
        return true;
    }
    DEFINE_PRIME0(has_spoopy_wrapper);
}