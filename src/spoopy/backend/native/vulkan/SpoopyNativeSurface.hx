package spoopy.backend.native.vulkan;

import spoopy.backend.native.SpoopyNativeCFFI;
import spoopy.graphics.SpoopyBuffer;

import lime._internal.backend.native.NativeWindow;
import lime.math.Rectangle;
import lime.app.Application;

@:access(spoopy.graphics.SpoopyBuffer)
class SpoopyNativeSurface {
    public var handle:Dynamic;

    private var handle_instance:Dynamic;
    private var handle_physical:Dynamic;
    private var handle_logical:Dynamic;
    private var handle_window_surface:Dynamic;

    private var name:String;
    private var version:Array<Int>;

    public function new(window:NativeWindow, application:Application) {
        name = application.meta.get("name");
        version = recursivelyGetVersionFromString(application.meta.get("version"));

        handle_window_surface = SpoopyNativeCFFI.spoopy_create_window_surface(window.handle);
        handle_instance = SpoopyNativeCFFI.spoopy_create_instance_device(handle_window_surface, name, version[0], version[1], version[2]);
        handle_physical = SpoopyNativeCFFI.spoopy_create_physical_device(handle_instance);
        handle_logical = SpoopyNativeCFFI.spoopy_create_logical_device(handle_instance, handle_physical);

        handle = SpoopyNativeCFFI.spoopy_create_surface(handle_instance, handle_physical, handle_logical, handle_window_surface);
    }

    public function setVertexBuffer(buffer:SpoopyBuffer, offset:Int, atIndex:Int):Void {
        //SpoopyNativeCFFI.spoopy_set_vertex_buffer(handle, buffer.__backend.handle, offset, atIndex);
    }

    public function useProgram(shader:SpoopyNativeShader) {
        SpoopyNativeCFFI.spoopy_bind_shader(handle, shader.pipeline);
    }

    public function cullFace(cullMode:SpoopyCullMode):Void {
        SpoopyNativeCFFI.spoopy_set_surface_cull_face(handle, cullMode);
    }

    public function winding(winding:SpoopyWinding):Void {
        SpoopyNativeCFFI.spoopy_set_surface_winding(handle, winding);
    }

    public function setViewport(rect:Rectangle):Void {
        SpoopyNativeCFFI.spoopy_set_surface_viewport(handle, rect);
    }

    public function beginRenderPass():Void {
        SpoopyNativeCFFI.spoopy_begin_render_pass(handle);
    }

    public function setRenderTarget(flags:Int, cd:SpoopyNativeTexture, dt:SpoopyNativeTexture, st:SpoopyNativeTexture):Void {
        SpoopyNativeCFFI.spoopy_set_surface_render_target(handle, flags, cd.handle, dt.handle, st.handle);
    }

    public function setScissorRect(rect:Rectangle, enabled:Bool):Void {
        SpoopyNativeCFFI.spoopy_set_surface_scissor_rect(handle, rect, enabled);
    }

    public function setLineWidth(width:Float):Void {
        SpoopyNativeCFFI.spoopy_set_surface_line_width(handle, width);
    }

    public function drawArray(primitiveType:Int, start:Int, count:Int):Void {
        SpoopyNativeCFFI.spoopy_surface_draw_arrays(handle, primitiveType, start, count);
    }

    public function drawElements(primitiveType:Int, indexFormat:Int, count:Int, offset:Int):Void {
        SpoopyNativeCFFI.spoopy_surface_draw_elements(handle, primitiveType, indexFormat, count, offset);
    }

    public function updateWindow():Void {
        SpoopyNativeCFFI.spoopy_update_window_surface(handle);
    }

    public function release():Void {
        SpoopyNativeCFFI.spoopy_release_window_surface(handle);
    }

    private function recursivelyGetVersionFromString(version:String):Array<Int> {
        var vS:Array<String> = version.split(".");
        var v:Array<Int> = [];

        for(version in vS) {
            v.push(Std.parseInt(version));
        }

        if(v.length < 3) {
            return recursivelyGetVersionFromString(version + ".0");
        }

        return v;
    }
}