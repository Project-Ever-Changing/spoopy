package spoopy.graphics;

import haxe.ds.ObjectMap;

import lime.app.IModule;
import lime.app.Application;
import lime.ui.Window;
import lime.graphics.RenderContextAttributes;
import lime.math.Matrix3;

@:access(spoopy.graphics.SpoopyWindowDisplay)
class SpoopyGraphicsModule implements IModule {
    @:noCompletion private var __application:Application;
    @:noCompletion private var __backend:BackendGraphicsModule;
    @:noCompletion private var __display:ObjectMap<Window, SpoopyWindowDisplay>;
    @:noCompletion private var __createFirstWindow:Bool = false;

    public function new() {
        __backend = new BackendGraphicsModule();
        __display = new ObjectMap<Window, SpoopyWindowDisplay>();
    }

    @:noCompletion private function __onCreateWindow(window:Window):Void {
        if(!__createFirstWindow) {
            __application.onUpdate.add(__onUpdate);
            __application.onExit.add(__onModuleExit, false, 0);

            #if spoopy_debug
            __backend.check();
            #end

            __createFirstWindow = true;
        }

        #if spoopy_debug
        __backend.checkContext(window);
        #end

        var display = new SpoopyWindowDisplay(window);

        __display.set(window, display);
        __backend.createContextStage(window, display.__viewportRect);
        display.createRenderPass();
        __backend.reset(display.__renderPass);
    }

    @:noCompletion private function __onUpdate(deltaTime:Int):Void {
        for(window in __application.windows) {
            __backend.acquireNextImage(window);
            __backend.record(window, __display.get(window).__renderPass, __display.get(window).__viewportRect);
        }

        // TODO: Add an event system that will have graphic wise events.
    }

    @:noCompletion private function __onModuleExit(code:Int):Void {
        // TODO: Dispatch anything in the future.
    }

    @:noCompletion private function __registerLimeModule(application:Application):Void {
        __application = application;

        application.onCreateWindow.add(__onCreateWindow);
    }

    @:noCompletion private function __unregisterLimeModule(application:Application):Void {
        __application = null;

        application.onCreateWindow.remove(__onCreateWindow);

        if(__createFirstWindow) {
            application.onUpdate.remove(__onUpdate);
		    application.onExit.remove(__onModuleExit);
        }
    }
}

#if spoopy_vulkan
typedef BackendGraphicsModule = spoopy.backend.native.SpoopyNativeGraphics;
#end