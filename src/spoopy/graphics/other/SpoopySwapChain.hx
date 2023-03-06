package spoopy.graphics.other;

import lime.ui.Window;
import lime.graphics.RenderContext;

import spoopy.app.SpoopyApplication;
import spoopy.window.WindowEventManager;
import spoopy.rendering.SpoopyCullMode;

@:access(lime.ui.Window)
class SpoopySwapChain extends WindowEventManager {
    #if (haxe >= "4.0.0")
    public final application:SpoopyApplication;
    #else
    @:final public var application:SpoopyApplication;
    #end

    public var cullMode(default, set):SpoopyCullMode = CULL_MODE_NONE;

    @:noCompletion private var __surface:SpoopyNativeSurface;
    @:noCompletion private var __cullDirty:Bool;

    public function new(application:SpoopyApplication) {
        this.application = application;
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

    override public function onWindowUpdate():Void {
        super.onWindowUpdate();

        if(__cullDirty) {
            __surface.cullFace(cullMode);
            __cullDirty = false;
        }

        __surface.updateWindow();

        onUpdate();

        __surface.release();
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
    }

    @:noCompletion override private function set_cullMode(value:SpoopyCullMode):SpoopyCullMode {
        if(cullMode == value) {
            return value;
        }

        __cullDirty = true;
        return cullMode = value;
    }
}

#if spoopy_vulkan
typedef SpoopyNativeSurface = spoopy.backend.native.vulkan.SpoopyNativeSurface;
#elseif spoopy_metal
typedef SpoopyNativeSurface = spoopy.backend.native.metal.SpoopyNativeSurface;
#end