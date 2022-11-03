package spoopy.backend;

#if (neko || cppia)
import lime.system.CFFI;
#end

class SpoopyCFFI {
    #if (cpp && !cppia)
    public static var spoopy_application_init = new cpp.Callable<Void->Void>(cpp.Prime._loadPrime("spoopy", "spoopy_application_init", "v", false));
    public static var spoopy_window_render = new cpp.Callable<cpp.Object->Void>(cpp.Prime._loadPrime("spoopy", "spoopy_apply_surface", "oov", false));

    /*
    * Testing Stuff
    */
    public static var spoopy_test_SDL = new cpp.Callable<Void->Int>(cpp.Prime._loadPrime("spoopy", "spoopy_test_SDL", "i", false));
    #elseif (neko || cppia)
    public static var spoopy_application_init = CFFI.load("spoopy", "spoopy_application_init", 0);
    public static var spoopy_window_render = CFFI.load("spoopy", "spoopy_apply_surface", 2);

    /*
    * Testing Stuff
    */
    public static var spoopy_test_SDL = CFFI.load("spoopy", "spoopy_test_SDL", 0);
    #else
    public static function spoopy_application_init():Void {
        return;
    }

    public static function spoopy_apply_surface(value:Dynamic, value:Dynamic):Void {
        return;
    }

    /*
    * Testing Stuff
    */
    public static function spoopy_test_SDL():Int {
        return 0;
    }
    #end
}