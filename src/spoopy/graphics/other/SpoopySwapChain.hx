package spoopy.graphics.other;

import lime.ui.Window;
import lime.math.Rectangle;

import spoopy.app.SpoopyApplication;
import spoopy.window.WindowEventManager;
import spoopy.frontend.storage.SpoopyBufferStorage;
import spoopy.backend.native.SpoopyNativeShader;
import spoopy.graphics.SpoopyBuffer;
import spoopy.rendering.command.SpoopyCommand;
import spoopy.rendering.SpoopyCullMode;
import spoopy.rendering.SpoopyWinding;
import spoopy.rendering.SpoopyDrawType;

@:access(lime.ui.Window)
class SpoopySwapChain extends WindowEventManager {
    #if (haxe >= "4.0.0")
    public final application:SpoopyApplication;
    #else
    @:final public var application:SpoopyApplication;
    #end

    public var buffers(default, null):SpoopyBufferStorage;

    public var atIndexVertex(default, null):Int = 0;

    public var cullFace:SpoopyCullMode = CULL_MODE_NONE;
    public var winding:SpoopyWinding = CLOCKWISE;

    @:noCompletion private var __surface:SpoopyNativeSurface;

    @:noCompletion private var __drawnCounter:Int = 0;

    public function new(application:SpoopyApplication) {
        this.application = application;
        this.buffers = new SpoopyBufferStorage(this);
        
        super();
    }

    public function create():Void {
        /*
        * Empty.
        */
    }

    public function onUpdate():Void {
        /*
        * Empty.
        */
    }

    public function useShaderProgram(shader:SpoopyNativeShader):Void {
        __surface.useProgram(shader);
    }

    public function setViewport(rect:Rectangle):Void {
        __surface.setViewport(rect);
    }

    public function setScissor(rect:Rectangle, enabled:Bool):Void {
        __surface.setScissorRect(rect, enabled);
    }

    public override function onWindowUpdate():Void {
        super.onWindowUpdate();

        atIndexVertex = 0;

        __surface.updateWindow();
        buffers.beginFrame();

        onUpdate();

        __surface.release();
    }

    private function drawBasedOnCommand(command:SpoopyCommand):Void {
        if(command.beforeCallback != null) {
            command.beforeCallback();
        }

        beginRenderPass();
        setVertexBuffer(command.vertexBuffer, 0);
        setLineWidth(command.lineWidth);

        if(command.drawType == ELEMENTS) {
            setIndexBuffer(command.indexBuffer);
        }else {

        }
    }

    private function beginRenderPass():Void {
        __surface.beginRenderPass();
        __surface.cullFace(cullFace);
        __surface.winding(winding);
    }

    private function setVertexBuffer(buffer:SpoopyBuffer, offset:Int):Void {
        __surface.setVertexBuffer(buffer, offset, atIndexVertex);
        atIndexVertex++;
    }

    private function setIndexBuffer(buffer:SpoopyBuffer):Void {
        __surface.setIndexBuffer(buffer);
    }

    private function drawElements():Void {
        
    }

    private function setLineWidth(width:Float):Void {
        __surface.setLineWidth(width);
    }

    @:noCompletion override private function __registerWindowModule(window:Window):Void {
        super.__registerWindowModule(window);
        __surface = new SpoopyNativeSurface(window.__backend, application);

        create();
    }

    @:noCompletion override private function __unregisterWindowModule(window:Window):Void {
        super.__unregisterWindowModule(window);

        __surface.release();
        __surface = null;

        buffers.destroy();
        buffers = null;
    }
}

#if spoopy_vulkan
typedef SpoopyNativeSurface = spoopy.backend.native.vulkan.SpoopyNativeSurface;
#elseif spoopy_metal
typedef SpoopyNativeSurface = spoopy.backend.native.metal.SpoopyNativeSurface;
#end