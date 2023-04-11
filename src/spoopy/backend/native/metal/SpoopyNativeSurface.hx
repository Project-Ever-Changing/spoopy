package spoopy.backend.native.metal;

import spoopy.backend.native.SpoopyNativeCFFI;
import spoopy.backend.native.SpoopyNativeShader;
import spoopy.obj.prim.SpoopyPrimitiveType;
import spoopy.graphics.SpoopyBuffer;
import spoopy.rendering.SpoopyCullMode;
import spoopy.rendering.SpoopyWinding;

import lime._internal.backend.native.NativeWindow;
import lime.math.Rectangle;
import lime.app.Application;
import lime.utils.Log;

@:access(spoopy.graphics.SpoopyBuffer)
@:access(spoopy.backend.native.SpoopyNativeShader)
class SpoopyNativeSurface {
    public var handle:Dynamic;
    public var device:Dynamic;

    public function new(window:NativeWindow, application:Application) {
        handle = SpoopyNativeCFFI.spoopy_create_window_surface(window.handle);
        SpoopyNativeCFFI.spoopy_assign_metal_surface(handle);

        device = SpoopyNativeCFFI.spoopy_get_metal_device_from_layer(handle, false);
    }

    public function setVertexBuffer(buffer:SpoopyBuffer, offset:Int, atIndex:Int):Void {
        SpoopyNativeCFFI.spoopy_set_vertex_buffer(handle, buffer.__buffer.handle, offset, atIndex);
    }

    public function setIndexBuffer(buffer:SpoopyBuffer):Void {
        SpoopyNativeCFFI.spoopy_set_index_buffer(handle, buffer.__buffer.handle);
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
        SpoopyNativeCFFI.spoopy_surface_begin_render_pass(handle);
    }

    public function setScissorRect(rect:Rectangle, enabled:Bool):Void {
        SpoopyNativeCFFI.spoopy_set_surface_scissor_rect(handle, rect, enabled);
    }

    public function setLineWidth(width:Float):Void {
        SpoopyNativeCFFI.spoopy_set_surface_line_width(handle, width);
    }

    public static function updateMetalDescriptor():Void {
        SpoopyNativeCFFI.spoopy_surface_update_descriptor(handle);
    }

    public function drawArray(primitiveType:SpoopyPrimitiveType, start:Int, count:Int):Void {
        SpoopyNativeCFFI.spoopy_surface_draw_arrays(handle, primitiveType, start, count);
    }

    public function drawElements(primitiveType:SpoopyPrimitiveType, indexFormat:Int, count:Int, offset:Int):Void {
        SpoopyNativeCFFI.spoopy_surface_draw_elements(handle, primitiveType, indexFormat, count, offset);
    }

    public function updateWindow():Void {
        SpoopyNativeCFFI.spoopy_update_window_surface(handle);
    }

    public function release():Void {
        #if spoopy_debug
        if(!SpoopyNativeCFFI.spoopy_surface_find_command_buffer(handle)) {
            Log.warn("Command buffer does not exist!");
        }
        #end

        SpoopyNativeCFFI.spoopy_release_window_surface(handle);
    }
}
