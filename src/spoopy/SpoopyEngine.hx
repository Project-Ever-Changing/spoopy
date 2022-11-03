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

        switch(SpoopyCFFI.spoopy_test_SDL()) {
            case 0:
                trace("SDL was not successful :(");
            case 1:
                trace("SDL worked successfully! :D");
            case 2:
                trace("SDL worked... but only with Lime");
        }
    }
}