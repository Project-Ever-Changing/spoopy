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

    public function new(application:SpoopyApplication) {
        this.application = application;
        this.buffers = new SpoopyBufferStorage(this);
        this.__scissorRect = new Rectangle(0, 0, 0, 0);
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

    public function setVertexBuffer(buffer:SpoopyBuffer, offset:Int):Void {
        __surface.setVertexBuffer(buffer, offset, atIndexVertex);
        atIndexVertex++;
    }

    public function drawBasedOnCommand(command:SpoopyCommand):Void {
        if(command.beforeCallback != null) {
            command.beforeCallback();
        }

        beginRenderPass();
    }

    public override function onWindowUpdate():Void {
        super.onWindowUpdate();

        atIndexVertex = 0;

        __surface.updateWindow();
        buffers.beginFrame();

        onUpdate();

        __surface.release();
    }

    private override function onWindowChangedSize(width:Int, height:Int):Void {
        super.onWindowChangedSize(width, height);
        __viewport = new Rectangle(0, 0, width, height);
    }

    private function beginRenderPass():Void {
        __surface.beginRenderPass();
        __surface.cullFace(cullFace);
        __surface.winding(winding);
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

    @:noCompletion private function get_viewport():Rectangle {
        return __viewport.clone();
    }
}

#if spoopy_vulkan
typedef SpoopyNativeSurface = spoopy.backend.native.vulkan.SpoopyNativeSurface;
#elseif spoopy_metal
typedef SpoopyNativeSurface = spoopy.backend.native.metal.SpoopyNativeSurface;
#end