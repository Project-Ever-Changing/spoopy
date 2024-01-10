package spoopy.backend.native;

import spoopy.graphics.SpoopyWindowContext;
import spoopy.backend.native.SpoopyNativeRenderTask;

import lime.math.Rectangle;
import lime.ui.Window;

@:access(lime.ui.Window)
@:access(spoopy.backend.native.SpoopyNativeRenderTask)
class SpoopyNativeGraphics {
    @:noCompletion private var __renderTask:SpoopyNativeRenderTask;

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
        __renderTask = new SpoopyNativeRenderTask(context);
    }
}