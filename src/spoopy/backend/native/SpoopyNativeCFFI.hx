package spoopy.backend.native;

#if (neko || cppia)
import lime.system.CFFI;
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
    public static var spoopy_get_buffer_length_bytes = new cpp.Callable<cpp.Object->Int>(cpp.Prime._loadPrime("lime", "spoopy_get_buffer_length_bytes", "oi", false));
    public static var spoopy_set_vertex_buffer = new cpp.Callable<cpp.Object->cpp.Object->Int->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_set_vertex_buffer", "ooiiv", false));
    public static var spoopy_create_shader = new cpp.Callable<cpp.Object->cpp.Object->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_shader", "ooo", false));
    public static var spoopy_create_shader_pipeline = new cpp.Callable<cpp.Object->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_shader_pipeline", "oo", false));
    public static var spoopy_specialize_shader = new cpp.Callable<cpp.Object->String->String->String->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_specialize_shader", "osssv", false));
    public static var spoopy_cleanup_shader = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_cleanup_shader", "ov", false));
    public static var spoopy_bind_shader = new cpp.Callable<cpp.Object->cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_bind_shader", "oov", false));
    public static var spoopy_compare_two_buffers = new cpp.Callable<cpp.Object->cpp.Object->Bool>(cpp.Prime._loadPrime("lime", "spoopy_compare_two_buffers", "oob", false));
    public static var spoopy_set_shader_uniform = new cpp.Callable<cpp.Object->cpp.Object->Int->Int->lime.utils.DataPointer->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_set_shader_uniform", "ooiidiv"));
    #end

    #if spoopy_metal
    public static var spoopy_create_window_surface = new cpp.Callable<cpp.Object->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_window_surface", "oo", false));
    public static var spoopy_update_window_surface = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_update_window_surface", "ov", false));
    public static var spoopy_release_window_surface = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_release_window_surface", "ov", false));
    public static var spoopy_assign_metal_surface = new cpp.Callable<cpp.Object->cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_assign_metal_surface", "oov", false));
    public static var spoopy_create_metal_default_device = new cpp.Callable<Void->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_metal_default_device", "o", false));
    public static var spoopy_create_metal_buffer = new cpp.Callable<cpp.Object->lime.utils.DataPointer->Int->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_metal_buffer", "odio", false));
    public static var spoopy_copy_buffer_to_buffer = new cpp.Callable<cpp.Object->lime.utils.DataPointer->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_copy_buffer_to_buffer", "odiv", false));
    public static var spoopy_surface_set_vertex_buffer = new cpp.Callable<cpp.Object->cpp.Object->Int->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_surface_set_vertex_buffer", "ooiiv", false));
    public static var spoopy_set_surface_cull_face = new cpp.Callable<cpp.Object->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_set_surface_cull_face", "oiv", false));
    public static var spoopy_get_buffer_length_bytes = new cpp.Callable<cpp.Object->Int>(cpp.Prime._loadPrime("lime", "spoopy_get_buffer_length_bytes", "oi", false));
    public static var spoopy_set_vertex_buffer = new cpp.Callable<cpp.Object->cpp.Object->Int->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_set_vertex_buffer", "ooiiv", false));
    public static var spoopy_spv_to_metal_shader = new cpp.Callable<String->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_spv_to_metal_shader", "so", false));
    public static var spoopy_create_shader = new cpp.Callable<cpp.Object->cpp.Object->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_shader", "ooo", false));
    public static var spoopy_create_shader_pipeline = new cpp.Callable<cpp.Object->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_shader_pipeline", "oo", false));
    public static var spoopy_specialize_shader = new cpp.Callable<cpp.Object->String->String->String->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_specialize_shader", "osssv", false));
    public static var spoopy_cleanup_shader = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_cleanup_shader", "ov", false));
    public static var spoopy_bind_shader = new cpp.Callable<cpp.Object->cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_bind_shader", "oov", false));
    public static var spoopy_create_metal_buffer_length = new cpp.Callable<cpp.Object->Int->Int->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_metal_buffer_length", "oiio", false));
    public static var spoopy_compare_two_buffers = new cpp.Callable<cpp.Object->cpp.Object->Bool>(cpp.Prime._loadPrime("lime", "spoopy_compare_two_buffers", "oob", false));
    public static var spoopy_set_shader_uniform = new cpp.Callable<cpp.Object->cpp.Object->Int->Int->lime.utils.DataPointer->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_set_shader_uniform", "ooiidiv"));
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
    public static var spoopy_release_window_surface = CFFI.load("lime", "spoopy_release_window_surface", 1);
    public static var spoopy_set_vertex_buffer = CFFI.load("lime", "spoopy_set_vertex_buffer", 4);
    public static var spoopy_create_shader = CFFI.load("lime", "spoopy_create_shader", 2);
    public static var spoopy_create_shader_pipeline = CFFI.load("lime", "spoopy_create_shader_pipeline", 1);
    public static var spoopy_specialize_shader = CFFI.load("lime", "spoopy_specialize_shader", 4);
    public static var spoopy_cleanup_shader = CFFI.load("lime", "spoopy_cleanup_shader", 1);
    public static var spoopy_bind_shader = CFFI.load("lime", "spoopy_bind_shader", 2);
    public static var spoopy_compare_two_buffers = CFFI.load("lime", "spoopy_compare_two_buffers", 2);
    public static var spoopy_set_shader_uniform = CFFI.load("lime", "spoopy_set_shader_uniform", 6);
    #end

    #if spoopy_metal
    public static var spoopy_create_window_surface = CFFI.load("lime", "spoopy_create_window_surface", 1);
    public static var spoopy_update_window_surface = CFFI.load("lime", "spoopy_update_window_surface", 1);
    public static var spoopy_release_window_surface = CFFI.load("lime", "spoopy_release_window_surface", 1);
    public static var spoopy_assign_metal_surface = CFFI.load("lime", "spoopy_assign_metal_surface", 2);
    public static var spoopy_create_metal_default_device = CFFI.load("lime", "spoopy_create_metal_default_device", 0);
    public static var spoopy_create_metal_buffer = CFFI.load("lime", "spoopy_create_metal_buffer", 3);
    public static var spoopy_copy_buffer_to_buffer = CFFI.load("lime", "spoopy_copy_buffer_to_buffer", 3);
    public static var spoopy_surface_set_vertex_buffer = CFFI.load("lime", "spoopy_surface_set_vertex_buffer", 4);
    public static var spoopy_set_surface_cull_face = CFFI.load("lime", "spoopy_set_surface_cull_face", 2);
    public static var spoopy_get_buffer_length_bytes = CFFI.load("lime", "spoopy_get_buffer_length_bytes", 1);
    public static var spoopy_set_vertex_buffer = CFFI.load("lime", "spoopy_set_vertex_buffer", 4);
    public static var spoopy_spv_to_metal_shader = CFFI.load("lime", "spoopy_spv_to_metal_shader", 1);
    public static var spoopy_create_shader = CFFI.load("lime", "spoopy_create_shader", 2);
    public static var spoopy_create_shader_pipeline = CFFI.load("lime", "spoopy_create_shader_pipeline", 1);
    public static var spoopy_specialize_shader = CFFI.load("lime", "spoopy_specialize_shader", 4);
    public static var spoopy_cleanup_shader = CFFI.load("lime", "spoopy_cleanup_shader", 1);
    public static var spoopy_bind_shader = CFFI.load("lime", "spoopy_bind_shader", 2);
    public static var spoopy_create_metal_buffer_length = CFFI.load("lime", "spoopy_create_metal_buffer_length", 3);
    public static var spoopy_compare_two_buffers = CFFI.load("lime", "spoopy_compare_two_buffers", 2);
    public static var spoopy_set_shader_uniform = CFFI.load("lime", "spoopy_set_shader_uniform", 6);
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

    public static function spoopy_set_vertex_buffer(surface:Dynamic, buffer:Dynamic, offset:Int, atIndex:Int):Void {
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

    public static function spoopy_compare_two_buffers(buffer1:Dynamic, buffer2:Dynamic):Bool {
        return false;
    }

    public static function spoopy_set_shader_uniform(shader:Dynamic, uniform:Dynamic, offset:Int, loc:Int, val:Float, numRegs:Int):Void {
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

    public static function spoopy_assign_metal_surface(value1:Dynamic, value2:Dynamic):Void {
        return;
    }

    public static function spoopy_create_metal_default_device():Dynamic {
        return null;
    }

    public static function spoopy_create_metal_buffer(buffer:Dynamic, data:Float, size:Int):Dynamic {
        return null;
    }

    public static function spoopy_copy_buffer_to_buffer(buffer1:Dynamic, data:Float, size:Int):Void {
        return;
    }

    public static function spoopy_surface_set_vertex_buffer(surface:Dynamic, buffer:Dynamic, offset:Int, atIndex:Int):Void {
        return;
    }

    public static function spoopy_set_surface_cull_face(surface:Dynamic, cullMode:Int):Void {
        return;
    }

    public static function spoopy_get_buffer_length_bytes(buffer:Dynamic):Int {
        return 0;
    }

    public static function spoopy_set_vertex_buffer(surface:Dynamic, buffer:Dynamic, offset:Int, atIndex:Int):Void {
        return;
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

    public static function spoopy_create_metal_buffer_length(device:Dynamic, length:Int, options:Int):Dynamic {
        return null;
    }

    public static function spoopy_compare_two_buffers(buffer1:Dynamic, buffer2:Dynamic):Bool {
        return false;
    }

    public static function spoopy_set_shader_uniform(shader:Dynamic, uniform:Dynamic, offset:Int, loc:Int, val:Float, numRegs:Int):Void {
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