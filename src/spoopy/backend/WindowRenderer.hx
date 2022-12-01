package spoopy.backend;

import spoopy.display.WindowStage;
import spoopy.display.WindowStage;
import spoopy.backend.SpoopyCFFI;
import lime.ui.Window;

@:access(lime.ui.Window)
@:access(spoopy.display.WindowStage)
@:access(spoopy.SpoopyDevice)
class WindowRenderer {
    public var handle:Dynamic;

    var parent:WindowStage;

    public function new(parent:WindowStage) {
        this.parent = parent;

        if(this.parent.__parent == null) {
            this.parent.__parent.__backend = new WindowBackend(this.parent.__parent);
        }
    }

    public function getWindowTitle(window:Window):String {
        #if (cpp && !cppia)
        /*
        if(window.__backend.handle != null) {
            trace(window.__backend.handle);
            //return SpoopyCFFI.spoopy_window_get_title(window.__backend.handle.sdlWindow);
        }
        */
        #end

        return "";
    }

    /*
    public function applyWindowSurface(device:SpoopyDevice):Void {
        #if !(air && js && html5 && flash)
        if(parent.parent.__backend.handle != null && device.__manager.handle != null) {
            
        }
        #end
    }
    */
}

#if air
@:noCompletion private typedef WindowBackend = lime._internal.backend.air.AIRWindow;
#elseif flash
@:noCompletion private typedef WindowBackend = lime._internal.backend.flash.FlashWindow;
#elseif (js && html5)
@:noCompletion private typedef WindowBackend = lime._internal.backend.html5.HTML5Window;
#else
@:noCompletion private typedef WindowBackend = lime._internal.backend.native.NativeWindow;
#end