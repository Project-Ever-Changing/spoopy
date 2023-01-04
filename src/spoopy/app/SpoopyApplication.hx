package spoopy.app;

import spoopy.display.SpoopyWindow;
import lime.ui.Window;
import lime.app.Application;
import lime.utils.Log;

class SpoopyApplication extends Application {
    public var spoopyWindow(get, null):SpoopyWindow;

    @:noCompletion var __spoopyWindow:SpoopyWindow;

    public function new() {
        super();
    }

    @:noCompletion override function __addWindow(window:Window):Void {
        super.__addWindow(window);

        __spoopyWindow = new SpoopyWindow(window);

        onSpoopyWindowCreated();
    }

    @:noCompletion function get_spoopyWindow():SpoopyWindow {
        if(spoopyWindow == null) {
            Log.error("SpoopyWindow is null!");
        }

        return __spoopyWindow;
    }

    /*
     * Called when Spoopy Window is created.
     */
    public function onSpoopyWindowCreated():Void {};
}