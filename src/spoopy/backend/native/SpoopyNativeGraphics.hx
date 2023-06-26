package spoopy.backend.native;

import lime.math.Rectangle;
import lime.ui.Window;

@:access(lime.ui.Window)
class SpoopyNativeGraphics {
    public function new() {
        // Empty
    }

    public function check():Void {
        SpoopyNativeCFFI.spoopy_check_graphics_module();
    }

    public function update():Void {
        SpoopyNativeCFFI.spoopy_update_graphics_module();
    }

    public function createContextStage(window:Window, viewport:Rectangle):Void {
        SpoopyNativeCFFI.spoopy_create_context_stage(window.__backend.handle, viewport);
    }
}