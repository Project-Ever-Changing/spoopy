package spoopy;

import spoopy.backend.SpoopyCFFI;
import lime.utils.Log;
import lime.app.Application;

@:access(spoopy.backend.SpoopyCFFI)
class SpoopyEngine {
    static var initializedApp:Bool = false;

    public static var device(default, null):SpoopyDevice;

    public static inline function init():Void {
        if(initializedApp) {
            Log.warn("You've already initialized this application!");
            return;
        }

        device = new SpoopyDevice();
        SpoopyCFFI.spoopy_application_init();
        initializedApp = true;
    }
}