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
    public static var spoopy_create_instance_device = new cpp.Callable<cpp.Object->String->Int->Int->Int->cpp.Object>(cpp.Prime._loadPrime("spoopy", "spoopy_create_instance_device", "osiiio", false));
    public static var spoopy_create_physical_device = new cpp.Callable<cpp.Object->cpp.Object>(cpp.Prime._loadPrime("spoopy", "spoopy_create_physical_device", "oo", false));
    public static var spoopy_create_logical_device = new cpp.Callable<cpp.Object->cpp.Object->cpp.Object>(cpp.Prime._loadPrime("spoopy", "spoopy_create_logical_device", "ooo", false));
    public static var spoopy_create_surface = new cpp.Callable<cpp.Object->cpp.Object->cpp.Object->cpp.Object->cpp.Object>(cpp.Prime._loadPrime("spoopy", "spoopy_create_surface", "ooooo", false));
    public static var spoopy_window_alert = new cpp.Object<cpp.Object->String->String->cpp.Void>(cpp.Prime._loadPrime("spoopy", "spoopy_window_alert", "ossv", false));
    public static var spoopy_window_close = new cpp.Object<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("spoopy", "spoopy_window_close", "ov", false));
    public static var spoopy_window_focus = new cpp.Object<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("spoopy", "spoopy_window_focus", "ov", false));

    #elseif (neko || cppia)
    public static var spoopy_application_init = CFFI.load("spoopy", "spoopy_application_init", 0);
    public static var spoopy_window_get_title = CFFI.load("spoopy", "spoopy_window_get_title", 1);
    public static var spoopy_create_window = CFFI.load("spoopy", "spoopy_create_window", 4);
    public static var spoopy_window_get_x = CFFI.load("spoopy", "spoopy_window_get_x", 1);
    public static var spoopy_window_get_y = CFFI.load("spoopy", "spoopy_window_get_y", 1);
    public static var spoopy_window_get_id = CFFI.load("spoopy", "spoopy_window_get_id", 1);
    public static var spoopy_window_get_scale = CFFI.load("spoopy", "spoopy_window_get_scale", 1);
    public static var spoopy_create_instance_device = CFFI.load("spoopy", "spoopy_create_instance_device", 5);
    public static var spoopy_create_physical_device = CFFI.load("spoopy", "spoopy_create_physical_device", 1);
    public static var spoopy_create_logical_device = CFFI.load("spoopy", "spoopy_create_logical_device", 2);
    public static var spoopy_create_surface = CFFI.load("spoopy", "spoopy_create_surface", 4);
    public static var spoopy_window_alert = CFFI.load("spoopy", "spoopy_window_alert", 3);
    public static var spoopy_window_close = CFFI.load("spoopy", "spoopy_window_close", 1);
    public static var spoopy_window_focus = CFFI.load("spoopy", "spoopy_window_focus", 1);

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

    public static function spoopy_window_alert(value:Dynamic, string1:String, string2:String):Void {
        return;
    }

    public static function spoopy_window_close(value:Dynamic):Void {
        return;
    }

    public static function spoopy_window_focus(value:Dynamic):Void {
        return;
    }
    #end
}