package spoopy;

import spoopy.backend.SpoopyCFFI;
import lime.utils.Log;
import lime.app.Application;

class SpoopyEngine {
    static var initializedApp:Bool = false;

    public static inline function init():Void {
        if(initializedApp) {
            Log.warn("You've already initialized this application!");
            return;
        }

        initializedApp = true;
    }
}