package spoopy.backend.native;

import spoopy.graphics.renderer.SpoopyRenderPass;

import lime.math.Rectangle;
import lime.ui.Window;

@:access(lime.ui.Window)
@:access(spoopy.graphics.renderer.SpoopyRenderPass)
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

    public function reset(renderPass:SpoopyRenderPass):Void {
        SpoopyNativeCFFI.spoopy_reset_graphics_module(renderPass.__backend.handle);
    }

    public function checkContext(window:Window):Void {
        SpoopyNativeCFFI.spoopy_check_context(window.__backend.handle);
    }

    public function createContextStage(window:Window, viewport:Rectangle):Void {
        SpoopyNativeCFFI.spoopy_create_context_stage(window.__backend.handle, viewport);
    }
}