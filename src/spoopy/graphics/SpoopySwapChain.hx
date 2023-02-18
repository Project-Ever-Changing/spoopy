

package spoopy.graphics;

import lime.ui.Window;
import lime.graphics.RenderContext;

import spoopy.app.SpoopyApplication;
import spoopy.window.WindowEventManager;

@:access(lime.ui.Window)
class SpoopySwapChain extends WindowEventManager {
    #if (haxe >= "4.0.0")
    public final application:SpoopyApplication;
    #else
    @:final public var application:SpoopyApplication;
    #end

    @:noCompletion private var __surface:SpoopyNativeSurface;

    public function new(application:SpoopyApplication) {
        this.application = application;
        super();
    }

    override public function onWindowUpdate():Void {
        super.onWindowUpdate();
        __surface.updateWindow();
    }

    @:noCompletion override private function __registerWindowModule(window:Window):Void {
        super.__registerWindowModule(window);

        __surface = new SpoopyNativeSurface(window.__backend, application);
    }

    @:noCompletion override private function __unregisterWindowModule(window:Window):Void {
        super.__unregisterWindowModule(window);

        __surface.release();
        __surface = null;
    }
}

#if spoopy_vulkan
typedef SpoopyNativeSurface = spoopy.backend.native.vulkan.SpoopyNativeSurface;
#elseif spoopy_metal
typedef SpoopyNativeSurface = spoopy.backend.native.metal.SpoopyNativeSurface;
#end