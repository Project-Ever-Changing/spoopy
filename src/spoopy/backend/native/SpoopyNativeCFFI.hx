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
    public static var spoopy_check_graphics_module = new cpp.Callable<Void->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_check_graphics_module", "v", false));
    public static var spoopy_resize_graphics_context = new cpp.Callable<cpp.Object->cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_resize_graphics_context", "oov", false));
    public static var spoopy_create_render_pass = new cpp.Callable<Void->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_render_pass", "o", false));
    public static var spoopy_add_subpass_dependency = new cpp.Callable<cpp.Object->Bool->Bool->Int->Int->Int->Int->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_add_subpass_dependency", "obbiiiiiv", false));
    public static var spoopy_add_color_attachment = new cpp.Callable<cpp.Object->Int->Int->Bool->Bool->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_add_color_attachment", "oiibbv", false));
    public static var spoopy_add_depth_attachment = new cpp.Callable<cpp.Object->Int->Int->Bool->Bool->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_add_depth_attachment", "oiibbv", false));
    public static var spoopy_create_subpass = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_create_subpass", "ov", false));
    public static var spoopy_create_renderpass = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_create_renderpass", "ov", false));
    public static var spoopy_check_context = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_check_context", "ov", false));
    public static var spoopy_create_context_stage = new cpp.Callable<cpp.Object->cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_create_context_stage", "oov", false));
    public static var spoopy_create_memory_reader = new cpp.Callable<String->Int->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_memory_reader", "sio", false));
    public static var spoopy_get_memory_length = new cpp.Callable<cpp.Object->Int>(cpp.Prime._loadPrime("lime", "spoopy_get_memory_length", "oi", false));
    public static var spoopy_get_memory_data = new cpp.Callable<cpp.Object->String>(cpp.Prime._loadPrime("lime", "spoopy_get_memory_data", "os", false));
    public static var spoopy_get_memory_position = new cpp.Callable<cpp.Object->Int>(cpp.Prime._loadPrime("lime", "spoopy_get_memory_position", "oi", false));
    public static var spoopy_create_pipeline = new cpp.Callable<Void->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_pipeline", "o", false));
    public static var spoopy_pipeline_set_input_assembly = new cpp.Callable<cpp.Object->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_pipeline_set_input_assembly", "oiv", false));
    public static var spoopy_pipeline_set_vertex_input = new cpp.Callable<cpp.Object->cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_pipeline_set_vertex_input", "oov", false));
    public static var spoopy_create_command_pool = new cpp.Callable<cpp.Object->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_command_pool", "oo", false));
    public static var spoopy_create_command_buffer = new cpp.Callable<cpp.Object->Bool->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_command_buffer", "obo", false));
    public static var spoopy_create_semaphore = new cpp.Callable<Void->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_semaphore", "o", false));
    public static var spoopy_create_entry = new cpp.Callable<cpp.Object->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_entry", "oo", false));
    public static var spoopy_entry_is_gpu_operation_complete = new cpp.Callable<cpp.Object->Bool>(cpp.Prime._loadPrime("lime", "spoopy_entry_is_gpu_operation_complete", "ob", false));
    public static var spoopy_dealloc_gpu_cffi_pointer = new cpp.Callable<Int->cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_dealloc_gpu_cffi_pointer", "iov", false));
    public static var spoopy_engine_apply = new cpp.Callable<Bool->Float->Float->Float->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_engine_apply", "bfffv", false));
    public static var spoopy_engine_bind_callbacks = new cpp.Callable<cpp.Object->cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_engine_bind_callbacks", "oov", false));
    public static var spoopy_engine_run_raw = new cpp.Callable<Void->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_engine_run_raw", "v", false));
    public static var spoopy_create_threading_semaphore = new cpp.Callable<Void->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_threading_semaphore", "o", false));
    public static var spoopy_threading_semaphore_wait = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_threading_semaphore_wait", "ov", false));
    public static var spoopy_threading_semaphore_set = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_threading_semaphore_set", "ov", false));
    public static var spoopy_threading_semaphore_destroy = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_threading_semaphore_destroy", "ov", false));
    #elseif (neko || cppia)
    public static var spoopy_check_graphics_module = CFFI.load("lime", "spoopy_check_graphics_module", 0);
    public static var spoopy_resize_graphics_context = CFFI.load("lime", "spoopy_resize_graphics_context", 2);
    public static var spoopy_create_render_pass = CFFI.load("lime", "spoopy_create_render_pass", 0);
    public static var spoopy_add_subpass_dependency = CFFI.load("lime", "spoopy_add_subpass_dependency", 8);
    public static var spoopy_add_color_attachment = CFFI.load("lime", "spoopy_add_color_attachment", 5);
    public static var spoopy_add_depth_attachment = CFFI.load("lime", "spoopy_add_depth_attachment", 5);
    public static var spoopy_create_subpass = CFFI.load("lime", "spoopy_create_subpass", 1);
    public static var spoopy_create_renderpass = CFFI.load("lime", "spoopy_create_renderpass", 1);
    public static var spoopy_check_context = CFFI.load("lime", "spoopy_check_context", 1);
    public static var spoopy_create_context_stage = CFFI.load("lime", "spoopy_create_context_stage", 2);
    public static var spoopy_create_memory_reader = CFFI.load("lime", "spoopy_create_memory_reader", 2);
    public static var spoopy_get_memory_length = CFFI.load("lime", "spoopy_get_memory_length", 1);
    public static var spoopy_get_memory_data = CFFI.load("lime", "spoopy_get_memory_data", 1);
    public static var spoopy_get_memory_position = CFFI.load("lime", "spoopy_get_memory_position", 1);
    public static var spoopy_create_pipeline = CFFI.load("lime", "spoopy_create_pipeline", 0);
    public static var spoopy_pipeline_set_input_assembly = CFFI.load("lime", "spoopy_pipeline_set_input_assembly", 2);
    public static var spoopy_pipeline_set_vertex_input = CFFI.load("lime", "spoopy_pipeline_set_vertex_input", 2);
    public static var spoopy_create_command_pool = CFFI.load("lime", "spoopy_create_command_pool", 1);
    public static var spoopy_create_command_buffer = CFFI.load("lime", "spoopy_create_command_buffer", 2);
    public static var spoopy_create_semaphore = CFFI.load("lime", "spoopy_create_semaphore", 0);
    public static var spoopy_create_entry = CFFI.load("lime", "spoopy_create_entry", 1);
    public static var spoopy_entry_is_gpu_operation_complete = CFFI.load("lime", "spoopy_entry_is_gpu_operation_complete", 1);
    public static var spoopy_dealloc_gpu_cffi_pointer = CFFI.load("lime", "spoopy_dealloc_gpu_cffi_pointer", 2);
    public static var spoopy_engine_apply = CFFI.load("lime", "spoopy_engine_apply", 4);
    public static var spoopy_engine_bind_callbacks = CFFI.load("lime", "spoopy_engine_bind_callbacks", 2);
    public static var spoopy_engine_run_raw = CFFI.load("lime", "spoopy_engine_run_raw", 0);
    public static var spoopy_create_threading_semaphore = CFFI.load("lime", "spoopy_create_threading_semaphore", 0);
    public static var spoopy_threading_semaphore_wait = CFFI.load("lime", "spoopy_threading_semaphore_wait", 1);
    public static var spoopy_threading_semaphore_set = CFFI.load("lime", "spoopy_threading_semaphore_set", 1);
    public static var spoopy_threading_semaphore_destroy = CFFI.load("lime", "spoopy_threading_semaphore_destroy", 1);
    #else
    public static function spoopy_check_graphics_module():Void {
        return;
    }

    public static function spoopy_resize_graphics_context(window:Dynamic, viewport:Dynamic):Void {
        return;
    }

    public static function spoopy_create_render_pass():Dynamic {
        return null;
    }

    public static function spoopy_add_subpass_dependency(renderPass:Dynamic, srcSubpass:Bool, dstSubpass:Bool, srcStageMask:Int, dstStageMask:Int, srcAccessMask:Int, dstAccessMask:Int, dependencyFlags:Int):Void {
        return;
    }

    public static function spoopy_add_color_attachment(renderPass:Dynamic, location:Int, format:Int, hasImageLayout:Bool, sampled:Bool):Void {
        return;
    }

    public static function spoopy_add_depth_attachment(renderPass:Dynamic, location:Int, format:Int, hasStencil:Bool, sampled:Bool):Void {
        return;
    }

    public static function spoopy_create_subpass(renderPass:Dynamic):Void {
        return;
    }

    public static function spoopy_create_renderpass(renderPass:Dynamic):Void {
        return;
    }

    public static function spoopy_check_context(context:Dynamic):Void {
        return;
    }

    public static function spoopy_create_context_stage(context:Dynamic, viewport:Dynamic):Void {
        return;
    }

    public static function spoopy_create_memory_reader(data:String, size:Int):Dynamic {
        return null;
    }

    public static function spoopy_get_memory_length(memory:Dynamic):Int {
        return 0;
    }

    public static function spoopy_get_memory_data(memory:Dynamic):String {
        return "";
    }

    public static function spoopy_get_memory_position(memory:Dynamic):Int {
        return 0;
    }

    public static function spoopy_create_pipeline():Dynamic {
        return null;
    }

    public static function spoopy_pipeline_set_input_assembly(pipeline:Dynamic, topology:Int):Void {
        return;
    }

    public static function spoopy_pipeline_set_vertex_input(pipeline:Dynamic, memory:Dynamic):Void {
        return;
    }

    public static function spoopy_create_command_pool(window:Dynamic):Dynamic {
        return null;
    }

    public static function spoopy_create_command_buffer(pool:Dynamic, begin:Bool):Dynamic {
        return null;
    }

    public static function spoopy_create_semaphore():Dynamic {
        return null;
    }

    public static function spoopy_create_entry(window:Dynamic):Dynamic {
        return null;
    }

    public static function spoopy_entry_is_gpu_operation_complete(entry:Dynamic):Bool {
        return false;
    }

    public static function spoopy_dealloc_gpu_cffi_pointer(type:Int, handle:Dynamic):Void {
        return;
    }

    public static function spoopy_engine_apply(cpuLimiterEnabled:Bool, updateFPS:Float, drawFPS:Float, timeScale:Float):Void {
        return;
    }

    public static function spoopy_engine_bind_callbacks(updateCallback:Dynamic, drawCallback:Dynamic):Void {
        return;
    }

    public static function spoopy_engine_run_raw():Void {
        return;
    }

    public static function spoopy_create_threading_semaphore():Dynamic {
        return null;
    }

    public static function spoopy_threading_semaphore_wait(semaphore:Dynamic):Void {
        return;
    }

    public static function spoopy_threading_semaphore_set(semaphore:Dynamic):Void {
        return;
    }

    public static function spoopy_threading_semaphore_destroy(semaphore:Dynamic):Void {
        return;
    }
    #end
}