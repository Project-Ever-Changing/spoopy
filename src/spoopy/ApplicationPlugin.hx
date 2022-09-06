package spoopy;

import spoopy.backend.SpoopyCFFI;
import lime.app.Application;

@:access(spoopy.backend.SpoopyCFFI)
class ApplicationPlugin {
    public static inline function init(app:Application):Void {
        SpoopyCFFI.spoopy_application_init();
    }
}