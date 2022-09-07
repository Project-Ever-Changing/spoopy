package spoopy;

import spoopy.backend.SpoopyCFFI;
import lime.app.Application;

@:access(spoopy.backend.SpoopyCFFI)
class SpoopyEngine {
    public static inline function init():Void {
        SpoopyCFFI.spoopy_application_init();
    }
}