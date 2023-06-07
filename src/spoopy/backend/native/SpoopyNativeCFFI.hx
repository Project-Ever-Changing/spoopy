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
    #elseif (neko || cppia)
    public static var spoopy_check_graphics_module = CFFI.load("lime", "spoopy_check_graphics_module", 0);
    public static var spoopy_update_graphics_module = CFFI.load("lime", "spoopy_update_graphics_module", 0);
    #else
    public static function spoopy_check_graphics_module():Void {
        return;
    }

    public static function spoopy_update_graphics_module():Void {
        return;
    }
    #end
}