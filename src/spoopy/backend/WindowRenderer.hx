package spoopy.backend;

import spoopy.SpoopyDevice;
import spoopy.display.WindowStage;

@:access(lime.ui.Window)
@:access(spoopy.display.WindowStage)
@:access(spoopy.SpoopyDevice)
class WindowRenderer {
    public var handle:Dynamic;

    var parent:WindowStage;

    public function new(parent:WindowStage) {
        this.parent = parent;
    }

    public function applyWindowSurface(device:SpoopyDevice):Void {
        #if !(air && js && html5 && flash)
        if(parent.parent.__backend.handle != null && device.__manager.handle != null) {
            
        }
        #end
    }
}