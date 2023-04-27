package spoopy.backend.native;

#if (neko || cppia)
import lime.system.CFFI;
#end

#if (cpp && !cppia)
import cpp.Float32;
#else
typedef Float32 = Float;
#end

#if (lime_doc_gen && !lime_cffi)
typedef CFFI = Dynamic;
typedef CFFIPointer = Dynamic;
#end

class SpoopyNativeCFFI {
    #if (cpp && !cppia)

    #if spoopy_vulkan
    public static var spoopy_create_instance_device = new cpp.Callable<cpp.Object->String->Int->Int->Int->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_instance_device", "osiiio", false));
    public static var spoopy_create_physical_device = new cpp.Callable<cpp.Object->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_physical_device", "oo", false));
    public static var spoopy_create_logical_device = new cpp.Callable<cpp.Object->cpp.Object->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_logical_device", "ooo", false));
    public static var spoopy_create_surface = new cpp.Callable<cpp.Object->cpp.Object->cpp.Object->cpp.Object->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_surface", "ooooo", false));
    public static var spoopy_create_window_surface = new cpp.Callable<cpp.Object->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_window_surface", "oo", false));
    public static var spoopy_update_window_surface = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_update_window_surface", "ov", false));
    public static var spoopy_release_window_surface = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_release_window_surface", "ov", false));
    public static var spoopy_set_surface_cull_face = new cpp.Callable<cpp.Object->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_set_surface_cull_face", "oiv", false));
    public static var spoopy_set_surface_winding = new cpp.Callable<cpp.Object->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_set_surface_winding", "oiv", false));
    public static var spoopy_set_surface_viewport = new cpp.Callable<cpp.Object->cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_set_surface_viewport", "oov", false));
    public static var spoopy_surface_begin_render_pass = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_surface_begin_render_pass", "ov", false));
    public static var spoopy_surface_draw_arrays = new cpp.Callable<cpp.Object->Int->Int->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_surface_draw_arrays", "oiiiv", false));
    public static var spoopy_surface_draw_elements = new cpp.Callable<cpp.Object->Int->Int->Int->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_surface_draw_elements", "oiiiiv", false));
    public static var spoopy_surface_find_command_buffer = new cpp.Callable<cpp.Object->Bool>(cpp.Prime._loadPrime("lime", "spoopy_surface_find_command_buffer", "ob", false));
    public static var spoopy_set_surface_scissor_rect = new cpp.Callable<cpp.Object->cpp.Object->Bool->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_set_surface_scissor_rect", "oobv", false));
    public static var spoopy_set_surface_line_width = new cpp.Callable<cpp.Object->Float32->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_set_surface_line_width", "ofv", false));
    public static var spoopy_create_buffer = new cpp.Callable<cpp.Object->Int->Int->Int->Int->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_buffer", "oiiiio", false));
    public static var spoopy_get_buffer_length_bytes = new cpp.Callable<cpp.Object->Int>(cpp.Prime._loadPrime("lime", "spoopy_get_buffer_length_bytes", "oi", false));
    public static var spoopy_update_buffer_data = new cpp.Callable<cpp.Object->lime.utils.DataPointer->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_update_buffer_data", "odiv", false));
    public static var spoopy_update_buffer_sub_data = new cpp.Callable<cpp.Object->lime.utils.DataPointer->Int->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_update_buffer_sub_data", "odiiv", false));
    public static var spoopy_set_vertex_buffer = new cpp.Callable<cpp.Object->cpp.Object->Int->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_set_vertex_buffer", "ooiiv", false));
    public static var spoopy_set_index_buffer = new cpp.Callable<cpp.Object->cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_set_index_buffer", "oov", false));
    public static var spoopy_buffer_begin_frame = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_buffer_begin_frame", "ov", false));
    public static var spoopy_create_shader = new cpp.Callable<cpp.Object->cpp.Object->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_shader", "ooo", false));
    public static var spoopy_create_shader_pipeline = new cpp.Callable<cpp.Object->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_shader_pipeline", "oo", false));
    public static var spoopy_specialize_shader = new cpp.Callable<cpp.Object->String->String->String->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_specialize_shader", "osssv", false));
    public static var spoopy_cleanup_shader = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_cleanup_shader", "ov", false));
    public static var spoopy_bind_shader = new cpp.Callable<cpp.Object->cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_bind_shader", "oov", false));
    public static var spoopy_set_shader_uniform = new cpp.Callable<cpp.Object->cpp.Object->Int->Int->lime.utils.DataPointer->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_set_shader_uniform", "ooiidiv", false));
    public static var spoopy_create_texture_descriptor = new cpp.Callable<Int->Int->Int->Int->Int->cpp.Object->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_texture_descriptor", "iiiiioo", false));
    public static var spoopy_update_texture_descriptor = new cpp.Callable<cpp.Object->cpp.Object->Int->Int->Int->Int->Int->cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_update_texture_descriptor", "ooiiiiiov", false));
    public static var spoopy_create_texture = new cpp.Callable<cpp.Object->cpp.Object->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_texture", "ooo", false));
    public static var spoopy_update_sampler_descriptor = new cpp.Callable<cpp.Object->cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_update_sampler_descriptor", "oov", false));
    public static var spoopy_set_surface_render_target = new cpp.Callable<cpp.Object->Int->cpp.Object->cpp.Object->cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_set_surface_render_target", "oiooov", false));
    #end

    #if spoopy_metal
    public static var spoopy_create_window_surface = new cpp.Callable<cpp.Object->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_window_surface", "oo", false));
    public static var spoopy_update_window_surface = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_update_window_surface", "ov", false));
    public static var spoopy_release_window_surface = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_release_window_surface", "ov", false));
    public static var spoopy_assign_metal_surface = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_assign_metal_surface", "ov", false));
    public static var spoopy_get_metal_device_from_layer = new cpp.Callable<cpp.Object->Bool->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_get_metal_device_from_layer", "obo", false));
    public static var spoopy_set_surface_cull_face = new cpp.Callable<cpp.Object->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_set_surface_cull_face", "oiv", false));
    public static var spoopy_set_surface_winding = new cpp.Callable<cpp.Object->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_set_surface_winding", "oiv", false));
    public static var spoopy_set_surface_viewport = new cpp.Callable<cpp.Object->cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_set_surface_viewport", "oov", false));
    public static var spoopy_surface_begin_render_pass = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_surface_begin_render_pass", "ov", false));
    public static var spoopy_surface_draw_arrays = new cpp.Callable<cpp.Object->Int->Int->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_surface_draw_arrays", "oiiiv", false));
    public static var spoopy_surface_draw_elements = new cpp.Callable<cpp.Object->Int->Int->Int->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_surface_draw_elements", "oiiiiv", false));
    public static var spoopy_surface_find_command_buffer = new cpp.Callable<cpp.Object->Bool>(cpp.Prime._loadPrime("lime", "spoopy_surface_find_command_buffer", "ob", false));
    public static var spoopy_set_surface_scissor_rect = new cpp.Callable<cpp.Object->cpp.Object->Bool->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_set_surface_scissor_rect", "oobv", false));
    public static var spoopy_set_surface_line_width = new cpp.Callable<cpp.Object->Float32->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_set_surface_line_width", "ofv", false));
    public static var spoopy_create_buffer = new cpp.Callable<cpp.Object->Int->Int->Int->Int->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_buffer", "oiiiio", false));
    public static var spoopy_get_buffer_length_bytes = new cpp.Callable<cpp.Object->Int>(cpp.Prime._loadPrime("lime", "spoopy_get_buffer_length_bytes", "oi", false));
    public static var spoopy_update_buffer_data = new cpp.Callable<cpp.Object->lime.utils.DataPointer->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_update_buffer_data", "odiv", false));
    public static var spoopy_update_buffer_sub_data = new cpp.Callable<cpp.Object->lime.utils.DataPointer->Int->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_update_buffer_sub_data", "odiiv", false));
    public static var spoopy_set_vertex_buffer = new cpp.Callable<cpp.Object->cpp.Object->Int->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_set_vertex_buffer", "ooiiv", false));
    public static var spoopy_set_index_buffer = new cpp.Callable<cpp.Object->cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_set_index_buffer", "oov", false));
    public static var spoopy_buffer_begin_frame = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_buffer_begin_frame", "ov", false));
    public static var spoopy_spv_to_metal_shader = new cpp.Callable<String->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_spv_to_metal_shader", "so", false));
    public static var spoopy_create_shader = new cpp.Callable<cpp.Object->cpp.Object->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_shader", "ooo", false));
    public static var spoopy_create_shader_pipeline = new cpp.Callable<cpp.Object->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_shader_pipeline", "oo", false));
    public static var spoopy_specialize_shader = new cpp.Callable<cpp.Object->String->String->String->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_specialize_shader", "osssv", false));
    public static var spoopy_cleanup_shader = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_cleanup_shader", "ov", false));
    public static var spoopy_bind_shader = new cpp.Callable<cpp.Object->cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_bind_shader", "oov", false));
    public static var spoopy_set_shader_uniform = new cpp.Callable<cpp.Object->cpp.Object->Int->Int->lime.utils.DataPointer->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_set_shader_uniform", "ooiidiv", false));
    public static var spoopy_create_texture_descriptor = new cpp.Callable<Int->Int->Int->Int->Int->cpp.Object->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_texture_descriptor", "iiiiioo", false));
    public static var spoopy_update_texture_descriptor = new cpp.Callable<cpp.Object->cpp.Object->Int->Int->Int->Int->Int->cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_update_texture_descriptor", "ooiiiiiov", false));
    public static var spoopy_create_texture = new cpp.Callable<cpp.Object->cpp.Object->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_texture", "ooo", false));
    public static var spoopy_update_sampler_descriptor = new cpp.Callable<cpp.Object->cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_update_sampler_descriptor", "oov", false));
    public static var spoopy_set_surface_render_target = new cpp.Callable<cpp.Object->Int->cpp.Object->cpp.Object->cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_set_surface_render_target", "oiooov", false));
    #end

    #if spoopy_example
    public static var spoopy_create_example_window = new cpp.Callable<String->Int->Int->Int->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_example_window", "siiio", false));
    #end

    public static var has_spoopy_wrapper = new cpp.Callable<Void->Bool>(cpp.Prime._loadPrime("lime", "has_spoopy_wrapper", "b", false));

    #elseif (neko || cppia)

    #if spoopy_vulkan
    public static var spoopy_create_instance_device = CFFI.load("lime", "spoopy_create_instance_device", 5);
    public static var spoopy_create_physical_device = CFFI.load("lime", "spoopy_create_physical_device", 1);
    public static var spoopy_create_logical_device = CFFI.load("lime", "spoopy_create_logical_device", 2);
    public static var spoopy_create_surface = CFFI.load("lime", "spoopy_create_surface", 4);
    public static var spoopy_create_window_surface = CFFI.load("lime", "spoopy_create_window_surface", 1);
    public static var spoopy_update_window_surface = CFFI.load("lime", "spoopy_update_window_surface", 1);
    public static var spoopy_set_surface_cull_face = CFFI.load("lime", "spoopy_set_surface_cull_face", 2);
    public static var spoopy_set_surface_winding = CFFI.load("lime", "spoopy_set_surface_winding", 2);
    public static var spoopy_set_surface_viewport = CFFI.load("lime", "spoopy_set_surface_viewport", 2);
    public static var spoopy_surface_begin_render_pass = CFFI.load("lime", "spoopy_surface_begin_render_pass", 1);
    public static var spoopy_surface_draw_arrays = CFFI.load("lime", "spoopy_surface_draw_arrays", 4);
    public static var spoopy_surface_draw_elements = CFFI.load("lime", "spoopy_surface_draw_elements", 5);
    public static var spoopy_surface_find_command_buffer = CFFI.load("lime", "spoopy_surface_find_command_buffer", 1);
    public static var spoopy_set_surface_scissor_rect = CFFI.load("lime", "spoopy_set_surface_scissor_rect", 3);
    public static var spoopy_set_surface_line_width = CFFI.load("lime", "spoopy_set_surface_line_width", 2);
    public static var spoopy_create_buffer = CFFI.load("lime", "spoopy_create_buffer", 5);
    public static var spoopy_get_buffer_length_bytes = CFFI.load("lime", "spoopy_get_buffer_length_bytes", 1);
    public static var spoopy_update_buffer_data = CFFI.load("lime", "spoopy_update_buffer_data", 3);
    public static var spoopy_update_buffer_sub_data = CFFI.load("lime", "spoopy_update_buffer_sub_data", 4);
    public static var spoopy_set_vertex_buffer = CFFI.load("lime", "spoopy_set_vertex_buffer", 4);
    public static var spoopy_set_index_buffer = CFFI.load("lime", "spoopy_set_index_buffer", 2);
    public static var spoopy_buffer_begin_frame = CFFI.load("lime", "spoopy_buffer_begin_frame", 1);
    public static var spoopy_release_window_surface = CFFI.load("lime", "spoopy_release_window_surface", 1);
    public static var spoopy_create_shader = CFFI.load("lime", "spoopy_create_shader", 2);
    public static var spoopy_create_shader_pipeline = CFFI.load("lime", "spoopy_create_shader_pipeline", 1);
    public static var spoopy_specialize_shader = CFFI.load("lime", "spoopy_specialize_shader", 4);
    public static var spoopy_cleanup_shader = CFFI.load("lime", "spoopy_cleanup_shader", 1);
    public static var spoopy_bind_shader = CFFI.load("lime", "spoopy_bind_shader", 2);
    public static var spoopy_set_shader_uniform = CFFI.load("lime", "spoopy_set_shader_uniform", 6);
    public static var spoopy_create_texture_descriptor = CFFI.load("lime", "spoopy_create_texture_descriptor", 6);
    public static var spoopy_update_texture_descriptor = CFFI.load("lime", "spoopy_update_texture_descriptor", 8);
    public static var spoopy_create_texture = CFFI.load("lime", "spoopy_create_texture", 2);
    public static var spoopy_update_sampler_descriptor = CFFI.load("lime", "spoopy_update_sampler_descriptor", 2);
    public static var spoopy_set_surface_render_target = CFFI.load("lime", "spoopy_set_surface_render_target", 5);
    #end

    #if spoopy_metal
    public static var spoopy_create_window_surface = CFFI.load("lime", "spoopy_create_window_surface", 1);
    public static var spoopy_update_window_surface = CFFI.load("lime", "spoopy_update_window_surface", 1);
    public static var spoopy_release_window_surface = CFFI.load("lime", "spoopy_release_window_surface", 1);
    public static var spoopy_assign_metal_surface = CFFI.load("lime", "spoopy_assign_metal_surface", 1);
    public static var spoopy_get_metal_device_from_layer = CFFI.load("lime", "spoopy_get_metal_device_from_layer", 2);
    public static var spoopy_set_surface_cull_face = CFFI.load("lime", "spoopy_set_surface_cull_face", 2);
    public static var spoopy_set_surface_winding = CFFI.load("lime", "spoopy_set_surface_winding", 2);
    public static var spoopy_set_surface_viewport = CFFI.load("lime", "spoopy_set_surface_viewport", 2);
    public static var spoopy_surface_begin_render_pass = CFFI.load("lime", "spoopy_surface_begin_render_pass", 1);
    public static var spoopy_surface_draw_arrays = CFFI.load("lime", "spoopy_surface_draw_arrays", 4);
    public static var spoopy_surface_draw_elements = CFFI.load("lime", "spoopy_surface_draw_elements", 5);
    public static var spoopy_surface_find_command_buffer = CFFI.load("lime", "spoopy_surface_find_command_buffer", 1);
    public static var spoopy_set_surface_scissor_rect = CFFI.load("lime", "spoopy_set_surface_scissor_rect", 3);
    public static var spoopy_set_surface_line_width = CFFI.load("lime", "spoopy_set_surface_line_width", 2);
    public static var spoopy_create_buffer = CFFI.load("lime", "spoopy_create_buffer", 5);
    public static var spoopy_get_buffer_length_bytes = CFFI.load("lime", "spoopy_get_buffer_length_bytes", 1);
    public static var spoopy_update_buffer_data = CFFI.load("lime", "spoopy_update_buffer_data", 3);
    public static var spoopy_update_buffer_sub_data = CFFI.load("lime", "spoopy_update_buffer_sub_data", 4);
    public static var spoopy_set_vertex_buffer = CFFI.load("lime", "spoopy_set_vertex_buffer", 4);
    public static var spoopy_set_index_buffer = CFFI.load("lime", "spoopy_set_index_buffer", 2);
    public static var spoopy_buffer_begin_frame = CFFI.load("lime", "spoopy_buffer_begin_frame", 1);
    public static var spoopy_spv_to_metal_shader = CFFI.load("lime", "spoopy_spv_to_metal_shader", 1);
    public static var spoopy_create_shader = CFFI.load("lime", "spoopy_create_shader", 2);
    public static var spoopy_create_shader_pipeline = CFFI.load("lime", "spoopy_create_shader_pipeline", 1);
    public static var spoopy_specialize_shader = CFFI.load("lime", "spoopy_specialize_shader", 4);
    public static var spoopy_cleanup_shader = CFFI.load("lime", "spoopy_cleanup_shader", 1);
    public static var spoopy_bind_shader = CFFI.load("lime", "spoopy_bind_shader", 2);
    public static var spoopy_set_shader_uniform = CFFI.load("lime", "spoopy_set_shader_uniform", 6);
    public static var spoopy_create_texture_descriptor = CFFI.load("lime", "spoopy_create_texture_descriptor", 6);
    public static var spoopy_update_texture_descriptor = CFFI.load("lime", "spoopy_update_texture_descriptor", 8);
    public static var spoopy_create_texture = CFFI.load("lime", "spoopy_create_texture", 2);
    public static var spoopy_update_sampler_descriptor = CFFI.load("lime", "spoopy_update_sampler_descriptor", 2);
    public static var spoopy_set_surface_render_target = CFFI.load("lime", "spoopy_set_surface_render_target", 5);
    #end

    #if spoopy_example
    public static var spoopy_create_example_window = CFFI.load("lime", "spoopy_create_example_window", 4);
    #end

    public static var has_spoopy_wrapper = CFFI.load("lime", "has_spoopy_wrapper", 0);

    #else

    #if spoopy_vulkan
    public static function spoopy_create_instance_device(value:Dynamic, string:String, int1:Int, int2:Int, int3:Int):Dynamic {
        return null;
    }

    public static function spoopy_create_physical_device(value:Dynamic):Dynamic {
        return null;
    }

    public static function spoopy_create_logical_device(value1:Dynamic, value2:Dynmaic) {
        return null;
    }

    public static function spoopy_create_surface(value1:Dynamic, value2:Dynamic, value3:Dynamic, value4:Dynamic):Dynamic {
        return null;
    }

    public static function spoopy_create_window_surface(value:Dynamic):Dynamic {
        return null;
    }

    public static function spoopy_update_window_update(value:Dynamic):Void {
        return;
    }

    public static function spoopy_release_window_update(value:Dynamic):Void {
        return;
    }

    public static function spoopy_set_surface_cull_face(surface:Dynamic, cullMode:Int):Void {
        return;
    }

    public static function spoopy_set_surface_winding(surface:Dynamic, winding:Int):Void {
        return;
    }

    public static function spoopy_set_surface_viewport(surface:Dynamic, viewport:Dynamic):Void {
        return;
    }

    public static function spoopy_surface_begin_render_pass(surface:Dynamic):Void {
        return;
    }

    public static function spoopy_surface_draw_arrays(surface:Dynamic, primitiveType:Int, start:Int, count:Int):Void {
        return;
    }

    public static function spoopy_surface_draw_elements(surface:Dynamic, primitiveType:Int, indexFormat:Int, count:Int, offset:Int):Void {
        return;
    }

    public static function spoopy_surface_find_command_buffer(surface:Dynmaic):Bool {
        return false;
    }

    public static function spoopy_set_surface_scissor_rect(surface:Dynamic, rect:Dynamic, enabled:Bool):Void {
        return;
    }

    public static function spoopy_set_surface_line_width(surface:Dynamic, width:Float):Void {
        return;
    }

    public static function spoopy_create_shader(window_surface:Dynamic, device:Dynamic):Dynamic {
        return null;
    }

    public static function spoopy_create_shader_pipeline(shader:Dynamic):Dynamic {
        return null;
    }

    public static function spoopy_specialize_shader(shader:Dynamic, name:String, fragment:String, vertex:String):Void {
        return;
    }

    public static function spoopy_cleanup_shader(shader:Dynamic):Void {
        return;
    }

    public static function spoopy_bind_shader(surface:Dynamic, shader:Dynamic):Void {
        return;
    }

    public static function spoopy_set_shader_uniform(shader:Dynamic, uniform:Dynamic, offset:Int, loc:Int, val:lime.utils.DataPointer, numRegs:Int):Void {
        return;
    }

    public static function spoopy_create_buffer(buffer_handle:Dynamic, size:Int, bucketSize:Int, type:Int, usage:Int):Dynamic {
        return null;
    }

    public static function spoopy_get_buffer_length_bytes(buffer:Dynamic):Int {
        return 0;
    }

    public static function spoopy_update_buffer_data(buffer:Dynamic, data:lime.utils.DataPointer, size:Int):Dynamic {
        return null;
    }

    public static function spoopy_update_buffer_sub_data(buffer:Dynamic, data:lime.utils.DataPointer, offset:Int, size:Int):Dynamic {
        return null;
    }

    public static function spoopy_set_vertex_buffer(surface:Dynamic, buffer:Dynamic, offset:Int, atIndex:Int):Void {
        return;
    }

    public static function spoopy_set_index_buffer(surface:Dynamic, buffer:Dynamic):Void {
        return;
    }

    public static function spoopy_buffer_begin_frame(buffer:Dynamic):Dynamic {
        return null;
    }

    public static function spoopy_create_texture_descriptor(width:Int, height:Int, type:Int, format:Int, usage:Int, sd:Dynamic):Dynamic {
        return null;
    }

    public static function spoopy_update_texture_descriptor(texture:Dynamic, td:Dynamic, width:Int, height:Int, type:Int, format:Int, usage:Int, sd:Dynamic):Void {
        return;
    }

    public static function spoopy_create_texture(device:Dynamic, descriptor:Dynamic):Dynamic {
        return null;
    }

    public static function spoopy_update_sampler_descriptor(texture:Dynamic, sd:Dynamic):Void {
        return;
    }

    public static function spoopy_set_surface_render_target(surface:Dynamic, flags:Int, ct:Dynamic, dt:Dynamic, st:Dynamic):Void {
        return;
    }
    #end

    #if spoopy_metal
    public static function spoopy_create_window_surface(value:Dynamic):Dynamic {
        return null;
    }

    public static function spoopy_update_window_update(value:Dynamic):Void {
        return;
    }

    public static function spoopy_release_window_update(value:Dynamic):Void {
        return;
    }

    public static function spoopy_assign_metal_surface(value1:Dynamic):Void {
        return;
    }

    public static function spoopy_get_metal_device_from_layer(surface:Dynamic, debug:Bool):Dynamic {
        return null;
    }

    public static function spoopy_set_surface_cull_face(surface:Dynamic, cullMode:Int):Void {
        return;
    }

    public static function spoopy_set_surface_winding(surface:Dynamic, winding:Int):Void {
        return;
    }

    public static function spoopy_set_surface_viewport(surface:Dynamic, viewport:Dynamic):Void {
        return;
    }

    public static function spoopy_surface_begin_render_pass(surface:Dynamic):Void {
        return;
    }

    public static function spoopy_surface_draw_arrays(surface:Dynamic, primitiveType:Int, start:Int, count:Int):Void {
        return;
    }

    public static function spoopy_surface_draw_elements(surface:Dynamic, primitiveType:Int, indexFormat:Int, count:Int, offset:Int):Void {
        return;
    }

    public static function spoopy_surface_find_command_buffer(surface:Dynmaic):Bool {
        return false;
    }

    public static function spoopy_set_surface_scissor_rect(surface:Dynamic, rect:Dynamic, enabled:Bool):Void {
        return;
    }

    public static function spoopy_set_surface_line_width(surface:Dynamic, width:Float):Void {
        return;
    }

    public static function spoopy_create_buffer(buffer_handle:Dynamic, size:Int, bucketSize:Int, type:Int, usage:Int):Dynamic {
        return null;
    }

    public static function spoopy_get_buffer_length_bytes(buffer:Dynamic):Int {
        return 0;
    }

    public static function spoopy_spv_to_metal_shader(shader:String):Dynamic {
        return null;
    }

    public static function spoopy_create_shader(window_surface:Dynamic, device:Dynamic):Dynamic {
        return null;
    }

    public static function spoopy_create_shader_pipeline(shader:Dynamic):Dynamic {
        return null;
    }

    public static function spoopy_specialize_shader(shader:Dynamic, name:String, fragment:String, vertex:String):Void {
        return;
    }

    public static function spoopy_cleanup_shader(shader:Dynamic):Void {
        return;
    }

    public static function spoopy_bind_shader(surface:Dynamic, shader:Dynamic):Void {
        return;
    }

    public static function spoopy_set_shader_uniform(shader:Dynamic, uniform:Dynamic, offset:Int, loc:Int, val:lime.utils.DataPointer, numRegs:Int):Void {
        return;
    }

    public static function spoopy_update_buffer_data(buffer:Dynamic, data:lime.utils.DataPointer, size:Int):Dynamic {
        return null;
    }

    public static function spoopy_update_buffer_sub_data(buffer:Dynamic, data:lime.utils.DataPointer, offset:Int, size:Int):Dynamic {
        return null;
    }

    public static function spoopy_set_vertex_buffer(surface:Dynamic, buffer:Dynamic, offset:Int, atIndex:Int):Void {
        return;
    }

    public static function spoopy_set_index_buffer(surface:Dynamic, buffer:Dynamic):Void {
        return;
    }

    public static function spoopy_buffer_begin_frame(buffer:Dynamic):Dynamic {
        return null;
    }

    public static function spoopy_create_texture_descriptor(width:Int, height:Int, type:Int, format:Int, usage:Int, sd:Dynamic):Dynamic {
        return null;
    }

    public static function spoopy_update_texture_descriptor(texture:Dynamic, td:Dynamic, width:Int, height:Int, type:Int, format:Int, usage:Int, sd:Dynamic):Void {
        return;
    }

    public static function spoopy_create_texture(device:Dynamic, descriptor:Dynamic):Dynamic {
        return null;
    }

    public static function spoopy_update_sampler_descriptor(texture:Dynamic, sd:Dynamic):Void {
        return;
    }

    public static function spoopy_set_surface_render_target(surface:Dynamic, flags:Int, ct:Dynamic, dt:Dynamic, st:Dynamic):Void {
        return;
    }
    #end

    #if spoopy_example
    public static function spoopy_create_example_window(title:String, width:Int, height:Int, flags:Int):Dynamic {
        return null;
    }
    #end

    public static function has_spoopy_wrapper():Bool {
        return false;
    }
    #end
}