package spoopy.backend;

#if (neko || cppia)
import lime.system.CFFI;
#end

class SpoopyCFFI {
    #if (cpp && !cppia)
    public static var spoopy_application_init = new cpp.Callable<Void->Void>(cpp.Prime._loadPrime("spoopy", "spoopy_application_init", "v", false));
    public static var spoopy_window_render = new cpp.Callable<cpp.Object->Void>(cpp.Prime._loadPrime("spoopy", "spoopy_apply_surface", "oov", false));
    #elseif (neko || cppia)
    public static var spoopy_application_init = CFFI.load("spoopy", "spoopy_application_init", 0);
    public static var spoopy_window_render = CFFI.load("spoopy", "spoopy_apply_surface", 2);
    #else
    public static function spoopy_application_init():Void {
        return;
    }

    public static function spoopy_apply_surface(value:Dynamic, value:Dynamic):Void {
        return;
    }
    #end
}