package spoopy.backend;

import spoopy.display.SpoopyWindow;
import spoopy.backend.SpoopyCFFI;
import lime.ui.Window;

@:access(lime.ui.Window)
@:access(spoopy.display.SpoopyWindow)
@:access(spoopy.SpoopyDevice)
class WindowRenderer {
    public var handle:Dynamic;

    var parent:SpoopyWindow;

    public function new(parent:SpoopyWindow) {
        this.parent = parent;
    }

    public function getWindowTitle(window:Window):String {
        #if (cpp && !cppia)
        if(window.__backend.handle != null) {
            trace(Reflect.getProperty(window.__backend.handle, "sdlWindow"));
            return SpoopyCFFI.spoopy_window_get_title(window.__backend.handle);
        }
        #end

        return "";
    }
}