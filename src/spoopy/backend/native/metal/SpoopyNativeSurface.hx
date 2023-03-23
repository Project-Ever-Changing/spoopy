package spoopy.backend.native.metal;

import spoopy.backend.native.SpoopyNativeCFFI;
import spoopy.backend.native.SpoopyNativeShader;
import spoopy.graphics.SpoopyBuffer;
import spoopy.rendering.SpoopyCullMode;

import lime._internal.backend.native.NativeWindow;
import lime.app.Application;

@:access(spoopy.graphics.SpoopyBuffer)
@:access(spoopy.backend.native.SpoopyNativeShader)
class SpoopyNativeSurface {
    public var handle:Dynamic;
    public var device:Dynamic;

    public function new(window:NativeWindow, application:Application) {
        handle = SpoopyNativeCFFI.spoopy_create_window_surface(window.handle);
        device = SpoopyNativeCFFI.spoopy_create_metal_default_device();

        SpoopyNativeCFFI.spoopy_assign_metal_surface(handle, device);
    }

    public function setVertexBuffer(buffer:SpoopyBuffer, offset:Int, atIndex:Int):Void {
        SpoopyNativeCFFI.spoopy_set_vertex_buffer(handle, buffer.__backend.handle, offset, device.atIndex);
    }

    public function useProgram(shader:SpoopyNativeShader) {
        SpoopyNativeCFFI.spoopy_bind_shader(handle, shader.pipeline);
    }

    public function cullFace(cullMode:SpoopyCullMode):Void {
        SpoopyNativeCFFI.spoopy_set_surface_cull_face(handle, cullMode);
    }

    public function updateWindow():Void {
        SpoopyNativeCFFI.spoopy_update_window_surface(handle);
    }

    public function release():Void {
        SpoopyNativeCFFI.spoopy_release_window_surface(handle);
    }
}