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
    #end

    #if spoopy_metal
    public static var spoopy_create_window_surface = new cpp.Callable<cpp.Object->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_window_surface", "oo", false));
    public static var spoopy_update_window_surface = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_update_window_surface", "ov", false));
    public static var spoopy_release_window_surface = new cpp.Callable<cpp.Object->cpp.Void>(cpp.Prime._loadPrime("lime", "spoopy_release_window_surface", "ov", false));

    public static var spoopy_create_metal_default_device = new cpp.Callable<Void->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_metal_default_device", "o", false));
    public static var spoopy_create_metal_buffer = new cpp.Callable<cpp.Object->Float->Int->cpp.Object>(cpp.Prime._loadPrime("lime", "spoopy_create_metal_buffer", "ofio", false));
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
    public static var spoopy_release_window_surface = CFFI.load("lime", "spoopy_release_window_surface", 1);
    #end

    #if spoopy_metal
    public static var spoopy_create_window_surface = CFFI.load("lime", "spoopy_create_window_surface", 1);
    public static var spoopy_update_window_surface = CFFI.load("lime", "spoopy_update_window_surface", 1);
    public static var spoopy_release_window_surface = CFFI.load("lime", "spoopy_release_window_surface", 1);

    public static var spoopy_create_metal_default_device = CFFI.load("lime", "spoopy_create_metal_default_device", 0);
    public static var spoopy_create_metal_buffer = CFFI.load("lime", "spoopy_create_metal_buffer", 3);
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
    

    public static function spoopy_create_metal_default_device():Dynamic {
        return null;
    }

    public static function spoopy_create_metal_buffer(buffer:Dynamic, data:Float, size:Int):Dynamic {
        return null;
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