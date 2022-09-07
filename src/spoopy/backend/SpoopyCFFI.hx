package spoopy.backend;

#if (neko || cppia)
import lime.system.CFFI;
#end

class SpoopyCFFI {
    #if (cpp && !cppia)
    public static var spoopy_application_init = new cpp.Callable<Void->Void>(cpp.Prime._loadPrime("spoopy", "spoopy_application_init", "v", false));
    #elseif (neko || cppia)
    public static var spoopy_application_init = CFFI.load("spoopy", "spoopy_application_init", 0);
    #else
    public static function spoopy_application_init():Void {
        return;
    }
    #end
}