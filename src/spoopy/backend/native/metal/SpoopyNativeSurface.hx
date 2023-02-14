package spoopy.backend.native.metal;

import spoopy.backend.native.SpoopyNativeCFFI;

import lime._internal.backend.native.NativeWindow;
import lime.app.Application;

class SpoopyNativeSurface {
    public var handle:Dynamic;

    public function new(window:NativeWindow, application:Application) {
        handle = SpoopyNativeCFFI.spoopy_create_window_surface(window.handle);
    }

    public function updateWindow():Void {
        SpoopyNativeCFFI.spoopy_update_window_surface(handle);
    }
}