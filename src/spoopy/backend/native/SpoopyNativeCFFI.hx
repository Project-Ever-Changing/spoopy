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
    public static var spoopy_acquire_image_graphics_module = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_acquire_image_graphics_module", "ov", false));
    public static var spoopy_record_graphics_module = new cpp.Callable<cpp.Object->cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_record_graphics_module", "oov", false));
    public static var spoopy_resize_graphics_context = new cpp.Callable<cpp.Object->cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_resize_graphics_context", "oov", false));
    public static var spoopy_reset_graphics_module = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_reset_graphics_module", "ov", false));
    public static var spoopy_create_render_pass = new cpp.Callable<Void->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_render_pass", "o", false));
    public static var spoopy_add_subpass_dependency = new cpp.Callable<cpp.Object->Bool->Bool->Int->Int->Int->Int->Int->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_add_subpass_dependency", "obbiiiiiv", false));
    public static var spoopy_add_color_attachment = new cpp.Callable<cpp.Object->Int->Int->Bool->Bool->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_add_color_attachment", "oiibbv", false));
    public static var spoopy_add_depth_attachment = new cpp.Callable<cpp.Object->Int->Int->Bool->Bool->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_add_depth_attachment", "oiibbv", false));
    public static var spoopy_create_subpass = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_create_subpass", "ov", false));
    public static var spoopy_create_renderpass = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_create_renderpass", "ov", false));
    public static var spoopy_check_context = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_check_context", "ov", false));
    public static var spoopy_create_context_stage = new cpp.Callable<cpp.Object->cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_create_context_stage", "oov", false));
    public static var spoopy_create_memory_reader = new cpp.Callable<String->Int->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_memory_reader", "sio", false));
    #elseif (neko || cppia)
    public static var spoopy_check_graphics_module = CFFI.load("lime", "spoopy_check_graphics_module", 0);
    public static var spoopy_acquire_image_graphics_module = CFFI.load("lime", "spoopy_acquire_image_graphics_module", 1);
    public static var spoopy_record_graphics_module = CFFI.load("lime", "spoopy_record_graphics_module", 2);
    public static var spoopy_resize_graphics_context = CFFI.load("lime", "spoopy_resize_graphics_context", 2);
    public static var spoopy_reset_graphics_module = CFFI.load("lime", "spoopy_reset_graphics_module", 1);
    public static var spoopy_create_render_pass = CFFI.load("lime", "spoopy_create_render_pass", 0);
    public static var spoopy_add_subpass_dependency = CFFI.load("lime", "spoopy_add_subpass_dependency", 8);
    public static var spoopy_add_color_attachment = CFFI.load("lime", "spoopy_add_color_attachment", 5);
    public static var spoopy_add_depth_attachment = CFFI.load("lime", "spoopy_add_depth_attachment", 5);
    public static var spoopy_create_subpass = CFFI.load("lime", "spoopy_create_subpass", 1);
    public static var spoopy_create_renderpass = CFFI.load("lime", "spoopy_create_renderpass", 1);
    public static var spoopy_check_context = CFFI.load("lime", "spoopy_check_context", 1);
    public static var spoopy_create_context_stage = CFFI.load("lime", "spoopy_create_context_stage", 2);
    public static var spoopy_create_memory_reader = CFFI.load("lime", "spoopy_create_memory_reader", 2);
    #else
    public static function spoopy_check_graphics_module():Void {
        return;
    }

    public static function spoopy_acquire_image_graphics_module(window:Dynamic):Void {
        return;
    }

    public static function spoopy_record_graphics_module(window:Dynamic, renderpass:Dynamic):Void {
        return;
    }

    public static function spoopy_resize_graphics_context(window:Dynamic, viewport:Dynamic):Void {
        return;
    }

    public static function spoopy_reset_graphics_module(renderPass:Dynamic):Void {
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
    #end
}