package spoopy.backend;

#if (neko || cppia)
import lime.system.CFFI;
#end

class SpoopyCFFI {
    #if (cpp && !cppia)
    public static var spoopy_application_init = new cpp.Callable<Void->Void>(cpp.Prime._loadPrime("spoopy", "spoopy_application_init", "v", false));
    public static var spoopy_window_get_title = new cpp.Callable<cpp.Object->cpp.Object>(cpp.Prime._loadPrime("spoopy", "spoopy_window_get_title", "oo", false));
    public static var spoopy_create_window = new cpp.Callable<Int->Int->Int->String->cpp.Object>(cpp.Prime._loadPrime("spoopy", "spoopy_create_window", "iiiso", false));
    public static var spoopy_window_get_x = new cpp.Callable<cpp.Object->Int>(cpp.Prime._loadPrime("spoopy", "spoopy_window_get_x", "oi", false));
    public static var spoopy_window_get_y = new cpp.Callable<cpp.Object->Int>(cpp.Prime._loadPrime("spoopy", "spoopy_window_get_y", "oi", false));
    public static var spoopy_window_get_id = new cpp.Callable<cpp.Object->Int>(cpp.Prime._loadPrime("spoopy", "spoopy_window_get_id", "oi", false));
    public static var spoopy_window_get_scale = new cpp.Callable<cpp.Object->Float>(cpp.Prime._loadPrime("spoopy", "spoopy_window_get_scale", "od", false));

    #elseif (neko || cppia)
    public static var spoopy_application_init = CFFI.load("spoopy", "spoopy_application_init", 0);
    public static var spoopy_window_get_title = CFFI.load("spoopy", "spoopy_window_get_title", 1);
    public static var spoopy_create_window = CFFI.load("spoopy", "spoopy_create_window", 4);
    public static var spoopy_window_get_x = CFFI.load("spoopy", "spoopy_window_get_x", 1);
    public static var spoopy_window_get_y = CFFI.load("spoopy", "spoopy_window_get_y", 1);
    public static var spoopy_window_get_id = CFFI.load("spoopy", "spoopy_window_get_id", 1);
    public static var spoopy_window_get_scale = CFFI.load("spoopy", "spoopy_window_get_scale", 1);

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

    public static function spoopy_window_get_x(value:Dynamic):Int {
        return 0;
    }

    public static function spoopy_window_get_y(value:Dynamic):Int {
        return 0;
    }

    public static function spoopy_window_get_id(value:Dynamic):Int {
        return 0;
    }

    public static function spoopy_window_get_scale(value:Dynamic):Float {
        return 0;
    }

    public static function spoopy_apply_surface(value:Dynamic, value:Dynamic):Void {
        return;
    }
    #end
}