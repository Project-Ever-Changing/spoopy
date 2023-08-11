package spoopy.graphics;

import haxe.ds.ObjectMap;

import lime.app.IModule;
import lime.app.Application;
import lime.ui.Window;
import lime.graphics.RenderContextAttributes;
import lime.graphics.RenderContext;
import lime.math.Matrix3;

@:access(spoopy.graphics.SpoopyWindowDisplay)
class SpoopyGraphicsModule implements IModule {
    @:noCompletion private var __application:Application;
    @:noCompletion private var __backend:BackendGraphicsModule;
    @:noCompletion private var __display:ObjectMap<Window, SpoopyWindowDisplay>;
    @:noCompletion private var __rendering:Bool = false;

    #if spoopy_debug
    @:noCompletion private var __createFirstWindow:Bool = false;
    #end

    public function new() {
        __backend = new BackendGraphicsModule();
        __display = new ObjectMap<Window, SpoopyWindowDisplay>();
    }

    @:noCompletion private function __onCreateWindow(window:Window):Void {
        #if spoopy_debug
        if(!__createFirstWindow) {
            __backend.check();
            __createFirstWindow = true;
        }

        //__backend.checkContext(window);
        #end

        var display = new SpoopyWindowDisplay(window);

        //__backend.createContextStage(window, display.__viewportRect);
        __windowResize(display);

        __display.set(window, display);
        display.createRenderPass();
        //__backend.reset(display.__renderPass);
    }

    @:noCompletion private function __windowResize(display:SpoopyWindowDisplay):Void {
        display.resize();
        //__backend.resize(display.__window, display.__viewportRect);

        //TODO: Maybe have an event system for this?
    }

    @:noCompletion private function __onWindowRender(context:RenderContext):Void { // The `RenderContext` is practically useless.
        if(__rendering) return;
        __rendering = true;

        //__backend.acquireNextImage(context.window);
        //__backend.record(context.window, __display.get(context.window).__renderPass);

        __rendering = false;
    }

    @:noCompletion private function __onWindowResize(window:Window, width:Int, height:Int):Void {
        if(window == null) {
            return;
        }

        __windowResize(__display.get(window));
    }

    @:noCompletion private function __onWindowCreate(window:Window):Void {
        window.onRender.add(__onWindowRender);
        window.onResize.add(__onWindowResize.bind(window));

        __onCreateWindow(window);
    }

    @:noCompletion private function __onUpdate(deltaTime:Int):Void {
        // TODO: Add an event system that will have graphic wise events.
    }

    @:noCompletion private function __onModuleExit(code:Int):Void {
        // TODO: Dispatch anything in the future.
    }

    @:noCompletion private function __registerLimeModule(application:Application):Void {
        __application = application;

        application.onCreateWindow.add(__onCreateWindow);
        application.onUpdate.add(__onUpdate);
        application.onExit.add(__onModuleExit, false, 0);
    }

    @:noCompletion private function __unregisterLimeModule(application:Application):Void {
        __application = null;

        application.onCreateWindow.remove(__onCreateWindow);
        application.onUpdate.remove(__onUpdate);
        application.onExit.remove(__onModuleExit);
    }
}

#if spoopy_vulkan
typedef BackendGraphicsModule = spoopy.backend.native.SpoopyNativeGraphics;
#end