package spoopy.graphics.other;

import lime.ui.Window;
import lime.math.Rectangle;

import spoopy.app.SpoopyApplication;
import spoopy.window.WindowEventManager;
import spoopy.frontend.storage.SpoopyBufferStorage;
import spoopy.backend.native.SpoopyNativeShader;
import spoopy.graphics.SpoopyBuffer;
import spoopy.rendering.SpoopyCullMode;
import spoopy.rendering.SpoopyWinding

@:access(lime.ui.Window)
class SpoopySwapChain extends WindowEventManager {
    #if (haxe >= "4.0.0")
    public final application:SpoopyApplication;
    #else
    @:final public var application:SpoopyApplication;
    #end

    public var buffers(default, null):SpoopyBufferStorage;

    public var atIndexVertex(default, null):Int = 0;

    public var cullMode(default, set):SpoopyCullMode = CULL_MODE_NONE;
    public var windingMode(default, set):SpoopyWinding = CLOCKWISE;

    @:noCompletion private var __surface:SpoopyNativeSurface;
    @:noCompletion private var __cullDirty:Bool;

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

    public function setVertexBuffer(buffer:SpoopyBuffer, offset:Int):Void {
        __surface.setVertexBuffer(buffer, offset, atIndexVertex);
        atIndexVertex++;
    }

    public override function onWindowUpdate():Void {
        super.onWindowUpdate();

        atIndexVertex = 0;

        if(__cullDirty) {
            __surface.cullFace(cullMode);
            __cullDirty = false;
        }

        __surface.updateWindow();
        buffers.beginFrame();

        onUpdate();

        __surface.release();
    }

    private override function onWindowChangedSize(width:Int, height:Int):Void {
        super.onWindowChangedSize(width, height);
        setViewport(0, 0, width, height);
    }

    private function setViewport(x:Int, y:Int, width:Int, height:Int):Void {
        var rect:Rectangle = new Rectangle(x, y, width, height);
        __surface.setViewport(rect);
        rect = null;
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

    @:noCompletion private function set_cullMode(value:SpoopyCullMode):SpoopyCullMode {
        if(cullMode == value) {
            return value;
        }

        __cullDirty = true;
        return cullMode = value;
    }

    @:noCompletion private function set_windingMode(value:SpoopyWinding):SpoopyWinding {
        if(windingMode == value) {
            return value;
        }

        __surface.winding(value);
        return windingMode = value;
    }
}

#if spoopy_vulkan
typedef SpoopyNativeSurface = spoopy.backend.native.vulkan.SpoopyNativeSurface;
#elseif spoopy_metal
typedef SpoopyNativeSurface = spoopy.backend.native.metal.SpoopyNativeSurface;
#end