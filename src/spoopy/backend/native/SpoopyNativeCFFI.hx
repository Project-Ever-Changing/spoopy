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
    public static var spoopy_update_graphics_module = new cpp.Callable<Void->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_update_graphics_module", "v", false));
    public static var spoopy_create_render_pass = new cpp.Callable<cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_render_pass", "o", false));
    public static var spoopy_add_color_attachment = new cpp.Callable<cpp.Object->Int-Int->Bool->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_add_color_attachment", "oiibv", false));
    public static var spoopy_add_depth_attachment = new cpp.Callable<cpp.Object->Int-Int->Bool->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_add_depth_attachment", "oiibv", false));
    #elseif (neko || cppia)
    public static var spoopy_check_graphics_module = CFFI.load("lime", "spoopy_check_graphics_module", 0);
    public static var spoopy_update_graphics_module = CFFI.load("lime", "spoopy_update_graphics_module", 0);
    public static var spoopy_create_render_pass = CFFI.load("lime", "spoopy_create_render_pass", 0);
    public static var spoopy_add_color_attachment = CFFI.load("lime", "spoopy_add_color_attachment", 4);
    public static var spoopy_add_depth_attachment = CFFI.load("lime", "spoopy_add_depth_attachment", 4);
    #else
    public static function spoopy_check_graphics_module():Void {
        return;
    }

    public static function spoopy_update_graphics_module():Void {
        return;
    }

    public static function spoopy_create_render_pass():Dynamic {
        return null;
    }

    public static function spoopy_add_color_attachment(renderPass:Dynamic, location:Int, format:Int, hasImageLayout:Bool):Void {
        return;
    }

    public static function spoopy_add_depth_attachment(renderPass:Dynamic, location:Int, format:Int, hasStencil:Bool):Void {
        return;
    }
    #end
}