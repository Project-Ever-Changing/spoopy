package spoopy.graphics;

import spoopy.window.IWindowModule;
import haxe.macro.Context;
import spoopy.utils.SpoopyLogger;
import haxe.ds.ObjectMap;

import lime.app.Application;
import lime.ui.Window;
import lime.graphics.RenderContextAttributes;
import lime.graphics.RenderContext;
import lime.math.Matrix3;

import spoopy.graphics.state.SpoopyStateManager;

/*
* Handles the creation of the window and the rendering of the window.
* As well as the overall graphics of the application.
*/

@:access(spoopy.graphics.SpoopyWindowContext)
class SpoopyGraphicsModule implements IWindowModule {
    @:noCompletion private var __backend:BackendGraphicsModule;
    @:noCompletion private var __context:SpoopyWindowContext;
    @:noCompletion private var __rendering:Bool = false;

    #if spoopy_debug
    @:noCompletion private var __createFirstWindow:Bool = false;
    #end

    public function new() {
        __backend = new BackendGraphicsModule();
    }

    @:noCompletion private function __onAddedWindow(window:Window):Void {
        #if spoopy_debug
        if(!__createFirstWindow) {
            __backend.check();
            __createFirstWindow = true;
        }

        __backend.checkContext(window);
        #end

        __context = new SpoopyWindowContext(window);

        __backend.createContextStage(window, __context.__viewportRect);
        __windowResize(__context);

        __context.createRenderPass();
    }

    @:noCompletion private function __windowResize(context:SpoopyWindowContext):Void {
        context.resize();
        __backend.resize(display.__window, display.__viewportRect);

        //TODO: Maybe have an event system for this?
    }

    @:noCompletion private function __onWindowRender(context:RenderContext):Void { // The `RenderContext` is practically useless.
        if(__rendering) return;
        __rendering = true;


        __rendering = false;
    }

    @:noCompletion private function __onWindowResize(window:Window, width:Int, height:Int):Void {
        if(window == null) {
            return;
        }

        __windowResize(__context);
    }

    @:noCompletion private function __registerWindowModule(window:Window):Void {
        if(window == null) {
            SpoopyLogger.error("The window is null! Unable to create a graphics module.");
            return;
        }

        window.onRender.add(__onWindowRender);
        window.onResize.add(__onWindowResize.bind(window));

        __onAddedWindow(window);
    }

    @:noCompletion private function __unregisterWindowModule(window:Window):Void {
        __context = null;
    }
}

#if spoopy_vulkan
typedef BackendGraphicsModule = spoopy.backend.native.SpoopyNativeGraphics;
#end