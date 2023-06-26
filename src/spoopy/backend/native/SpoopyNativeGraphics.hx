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

    public function checkContext(window:Window):Void {
        SpoopyNativeCFFI.spoopy_check_context(window.__backend.handle);
    }

    public function createContextStage(window:Window, viewport:Rectangle):Void {
        SpoopyNativeCFFI.spoopy_create_context_stage(window.__backend.handle, viewport);
    }

    public function buildContextStage(window:Window, renderpass:SpoopyRenderPass):Void {
        SpoopyNativeCFFI.spoopy_build_context_stage(window.__backend.handle, renderpass.__backend.handle);
    }
}