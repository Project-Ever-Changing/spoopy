package spoopy.backend.native.metal;

import spoopy.backend.native.SpoopyNativeCFFI;
import spoopy.rendering.SpoopyCullMode;

import lime._internal.backend.native.NativeWindow;
import lime.app.Application;

class SpoopyNativeSurface {
    public var handle:Dynamic;
    public var device:Dynamic;

    public function new(window:NativeWindow, application:Application) {
        handle = SpoopyNativeCFFI.spoopy_create_window_surface(window.handle);
        device = SpoopyNativeCFFI.spoopy_create_metal_default_device();

        SpoopyNativeCFFI.spoopy_assign_metal_surface(handle, device);
    }

    public function cullFace(cullMode:SpoopyNativeCFFI):Void {

    }

    public function updateWindow():Void {
        SpoopyNativeCFFI.spoopy_update_window_surface(handle);
    }

    public function release():Void {
        SpoopyNativeCFFI.spoopy_release_window_surface(handle);
    }
}