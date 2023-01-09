package spoopy.backend;

#if (neko || cppia)
import lime.system.CFFI;
#end

class SpoopyCFFI {
    #if (cpp && !cppia)
    public static var spoopy_application_init = new cpp.Callable<Void->Void>(cpp.Prime._loadPrime("spoopy", "spoopy_application_init", "v", false));
    public static var spoopy_window_get_title = new cpp.Callable<cpp.Object->cpp.Object>(cpp.Prime._loadPrime("spoopy", "spoopy_window_get_title", "oo", false));
    public static var spoopy_create_window = new cpp.Callable<Int->Int->Int->String->cpp.Object>(cpp.Prime._loadPrime("spoopy", "spoopy_create_window", "iiiso", false));

    #elseif (neko || cppia)
    public static var spoopy_application_init = CFFI.load("spoopy", "spoopy_application_init", 0);
    public static var spoopy_window_get_title = CFFI.load("spoopy", "spoopy_window_get_title", 1);
    public static var spoopy_create_window = CFFI.load("spoopy", "spoopy_create_window", 4);
    
    #else
    public static function spoopy_application_init():Void {
        return;
    }

    public static function spoopy_window_get_title(value:Dynamic):Dynamic {
        return null;
    }

    public static function spoopy_create_window(width:Int, height:Int, flags:Int, title:String):Dynamic {
        return null;
    }

    public static function spoopy_apply_surface(value:Dynamic, value:Dynamic):Void {
        return;
    }
    #end
}