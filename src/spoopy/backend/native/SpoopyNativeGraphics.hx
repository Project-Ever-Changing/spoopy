package spoopy.backend.native;

import spoopy.graphics.SpoopyWindowContext;
import spoopy.graphics.renderer.SpoopyRenderPass;

import lime.math.Rectangle;
import lime.ui.Window;

@:access(lime.ui.Window)
@:access(spoopy.graphics.renderer.SpoopyRenderPass)
class SpoopyNativeGraphics {
    @:noCompletion private var __renderPass:SpoopyRenderPass;

    public function new() {
        // Empty
    }

    public function check():Void {
        SpoopyNativeCFFI.spoopy_check_graphics_module();
    }

    public function resize(window:Window, viewport:Rectangle):Void {
        SpoopyNativeCFFI.spoopy_resize_graphics_context(window.__backend.handle, viewport);
    }

    public function checkContext(window:Window):Void {
        SpoopyNativeCFFI.spoopy_check_context(window.__backend.handle);
    }

    public function createContextStage(window:Window, viewport:Rectangle):Void {
        SpoopyNativeCFFI.spoopy_create_context_stage(window.__backend.handle, viewport);
    }

    public function initSwapChain(context:SpoopyWindowContext):Void {
        if(__renderPass == null) {
            __renderPass = new SpoopyRenderPass(context);
        }
    }
}