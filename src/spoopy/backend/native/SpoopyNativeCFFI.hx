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
    public static var spoopy_device_lock_fence = new cpp.Callable<Void->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_device_lock_fence", "v", false));
    public static var spoopy_device_unlock_fence = new cpp.Callable<Void->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_device_unlock_fence", "v", false));
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
    public static var spoopy_recreate_swapchain = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_recreate_swapchain", "ov", false));
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
    public static var spoopy_create_gpu_fence = new cpp.Callable<Bool->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_gpu_fence", "bo", false));
    public static var spoopy_set_gpu_fence_signal = new cpp.Callable<cpp.Object->Bool->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_set_gpu_fence_signal", "obv", false));
    public static var spoopy_wait_gpu_fence = new cpp.Callable<cpp.Object->Int->Bool>(cpp.Prime._loadPrime("lime", "spoopy_wait_gpu_fence", "oib", false));
    public static var spoopy_reset_gpu_fence = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_reset_gpu_fence", "ov", false));
    public static var spoopy_device_acquire_next_image = new cpp.Callable<cpp.Object->cpp.Object->cpp.Object->Int->Int->Int>(cpp.Prime._loadPrime("lime", "spoopy_device_acquire_next_image", "oooiii", false));
    public static var spoopy_device_init_swapchain = new cpp.Callable<cpp.Object->cpp.Object->Void>(cpp.Prime._loadPrime("lime", "spoopy_device_init_swapchain", "oov", false));
    public static var spoopy_device_get_swapchain_image_count = new cpp.Callable<cpp.Object->Int>(cpp.Prime._loadPrime("lime", "spoopy_device_get_swapchain_image_count", "oi", false));
    public static var spoopy_device_destroy_swapchain = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_device_destroy_swapchain", "ov", false));
    public static var spoopy_device_create_swapchain = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_device_create_swapchain", "ov", false));
    public static var spoopy_device_set_swapchain_size = new cpp.Callable<cpp.Object->Int->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_device_set_swapchain_size", "oiiv", false));
    public static var spoopy_queue_submit = new cpp.Callable<cpp.Object->cpp.Object->cpp.Object->Int->cpp.Object->Int>(cpp.Prime._loadPrime("lime", "spoopy_queue_submit", "oooioi", false));
    public static var spoopy_command_buffer_begin_record = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_command_buffer_begin_record", "ov", false));
    public static var spoopy_command_buffer_end_render_pass = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_command_buffer_end_render_pass", "ov", false));
    public static var spoopy_command_buffer_end_record = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_command_buffer_end_record", "ov", false));
    public static var spoopy_command_buffer_free = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_command_buffer_free", "ov", false));
    public static var spoopy_device_present_image = new cpp.Callable<cpp.Object->cpp.Object->Int>(cpp.Prime._loadPrime("lime", "spoopy_device_present_image", "ooi", false));
    public static var spoopy_device_recreate_swapchain = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_device_recreate_swapchain", "ov", false));
    public static var spoopy_command_buffer_reset = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_command_buffer_reset", "ov", false));
    #elseif (neko || cppia)
    public static var spoopy_check_graphics_module = CFFI.load("lime", "spoopy_check_graphics_module", 0);
    public static var spoopy_resize_graphics_context = CFFI.load("lime", "spoopy_resize_graphics_context", 2);
    public static var spoopy_device_lock_fence = CFFI.load("lime", "spoopy_device_lock_fence", 0);
    public static var spoopy_device_unlock_fence = CFFI.load("lime", "spoopy_device_unlock_fence", 0);
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
    public static var spoopy_recreate_swapchain = CFFI.load("lime", "spoopy_recreate_swapchain", 1);
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
    public static var spoopy_create_gpu_fence = CFFI.load("lime", "spoopy_create_gpu_fence", 1);
    public static var spoopy_set_gpu_fence_signal = CFFI.load("lime", "spoopy_set_gpu_fence_signal", 2);
    public static var spoopy_wait_gpu_fence = CFFI.load("lime", "spoopy_wait_gpu_fence", 2);
    public static var spoopy_reset_gpu_fence = CFFI.load("lime", "spoopy_reset_gpu_fence", 1);
    public static var spoopy_device_acquire_next_image = CFFI.load("lime", "spoopy_device_acquire_next_image", 5);
    public static var spoopy_device_init_swapchain = CFFI.load("lime", "spoopy_device_init_swapchain", 2);
    public static var spoopy_device_get_swapchain_image_count = CFFI.load("lime", "spoopy_device_get_swapchain_image_count", 1);
    public static var spoopy_device_destroy_swapchain = CFFI.load("lime", "spoopy_device_destroy_swapchain", 1);
    public static var spoopy_device_create_swapchain = CFFI.load("lime", "spoopy_device_create_swapchain", 1);
    public static var spoopy_device_set_swapchain_size = CFFI.load("lime", "spoopy_device_create_swapchain", 3);
    public static var spoopy_queue_submit = CFFI.load("lime", "spoopy_queue_submit", 5);
    public static var spoopy_command_buffer_end_render_pass = CFFI.load("lime", "spoopy_command_buffer_end_render_pass", 1);
    public static var spoopy_command_buffer_begin_record = CFFI.load("lime", "spoopy_command_buffer_begin_record", 1);
    public static var spoopy_command_buffer_end_record = CFFI.load("lime", "spoopy_command_buffer_end_record", 1);
    public static var spoopy_command_buffer_free = CFFI.load("lime", "spoopy_command_buffer_free", 1);
    public static var spoopy_device_present_image = CFFI.load("lime", "spoopy_device_present_image", 2);
    public static var spoopy_device_recreate_swapchain = CFFI.load("lime", "spoopy_device_recreate_swapchain", 1);
    public static var spoopy_command_buffer_reset = CFFI.load("lime", "spoopy_command_buffer_reset", 1);
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

    public static function spoopy_recreate_swapchain(semaphore:Dynamic):Void {
        return;
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

    public static function spoopy_device_lock_fence():Void {
        return;
    }

    public static function spoopy_device_unlock_fence():Void {
        return;
    }

    public static function spoopy_create_gpu_fence(signaled:Bool):Dynamic {
        return null;
    }

    public static function spoopy_set_gpu_fence_signal(fence:Dynamic, signal:Bool):Void {
        return;
    }

    public static function spoopy_wait_gpu_fence(fence:Dynamic, nanoseconds:Int):Bool {
        return false;
    }

    public static function spoopy_reset_gpu_fence(fence:Dynamic):Void {
        return;
    }

    public static function spoopy_device_acquire_next_image(context:Dynamic, imageAvailableSemaphore:Dynamic, fence:Dynamic, prevSemaphoreIndex:Int, semaphoreIndex:Int):Int {
        return 0;
    }

    public static function spoopy_device_init_swapchain(window:Dynamic, callback:Dynamic):Void {
        return;
    }

    public static function spoopy_device_get_swapchain_image_count(window:Dynamic):Int {
        return 0;
    }

    public static function spoopy_device_destroy_swapchain(window:Dynamic):Void {
        return;
    }

    public static function spoopy_device_create_swapchain(window:Dynamic):Void {
        return;
    }

    public static function spoopy_device_set_swapchain_size(window:Dynamic, width:Int, height:Int):Void {
        return;
    }

    public static function spoopy_queue_submit(cmd_buffer:Dynamic, fence:Dynamic, rawWaitSemaphores:Dynamic, state:Int, signalSemaphore:Dynamic):Int {
        return 0;
    }

    public static function spoopy_command_buffer_begin_record(cmd_buffer:Dynamic):Void {
        return;
    }

    public static function spoopy_command_buffer_end_render_pass(cmd_buffer:Dynamic):Void {
        return;
    }

    public static function spoopy_command_buffer_end_record(cmd_buffer:Dynamic):Void {
        return;
    }

    public static function spoopy_command_buffer_free(cmd_buffer:Dynamic):Void {
        return;
    }

    public static function spoopy_device_present_image(window:Dynamic, semaphore:Dynamic):Int {
        return 0;
    }

    public static function spoopy_device_recreate_swapchain(window:Dynamic):Void {
        return;
    }

    public static function spoopy_command_buffer_reset(cmd_buffer:Dynamic):Void {
        return;
    }
    #end
}