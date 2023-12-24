package spoopy.graphics;

import spoopy.utils.destroy.SpoopyDestroyQueue;
import spoopy.window.IWindowModule;
import spoopy.utils.SpoopyLogger;
import spoopy.graphics.state.SpoopyStateManager;
import spoopy.graphics.modules.SpoopyEntry;
import spoopy.graphics.modules.SpoopyGPUObject;
import spoopy.app.SpoopyEngine;
import spoopy.events.SpoopyEvent;
import lime.app.Application;
import lime.ui.Window;
import lime.graphics.RenderContextAttributes;
import lime.graphics.RenderContext;
import lime.math.Matrix3;

/*
* Handles the creation of the window and the rendering of the window.
* As well as the overall graphics of the application.
*/

#if (haxe_ver >= 4.0) enum #else @:enum #end abstract GraphicsEventType(String) {
    var DRAW_FRAME = "sgm-drawFrame";
    var UPDATE_FRAME = "sgm-updateFrame";
}

@:access(spoopy.graphics.SpoopyWindowContext)
class SpoopyGraphicsModule implements IWindowModule {
    public var window(get, never):Window;
    public var frameCount(default, null):UInt = 0;

    @:noCompletion private var __backend:BackendGraphicsModule;
    @:noCompletion private var __context:SpoopyWindowContext;
    @:noCompletion private var __deletionQueue:SpoopyDestroyQueue<SpoopyEntry>;
    @:noCompletion private var __tempStateManager:SpoopyStateManager;
    @:noCompletion private var __engine:SpoopyEngine;

    @:noCompletion private var __rendering:Bool = false;

    #if spoopy_debug
    @:noCompletion private var __createFirstWindow:Bool = false;
    #end

    public function new(engine:SpoopyEngine, ?stateManager:SpoopyStateManager) {
        __backend = new BackendGraphicsModule();
        __deletionQueue = new SpoopyDestroyQueue<SpoopyEntry>();
        __tempStateManager = stateManager;
        __engine = engine;
    }

    /*
    * Helpful wrapper methods
    */

    public function enqueueDeletionObj(item:SpoopyGPUObject, frame:UInt):Void {
        if(item == null) {
            SpoopyLogger.error("The item is null! Unable to enqueue deletion.");
            return;
        }

        var entry = new SpoopyEntry(this, __context, frame, item);
        __deletionQueue.enqueue(entry);
    }


    /**
     * Backend methods
     */

    @:noCompletion private function __onAddedWindow(window:Window):Void {
        #if spoopy_debug
        if(!__createFirstWindow) {
            __backend.check();
            __createFirstWindow = true;
        }

        __backend.checkContext(window);
        #end

        __context = new SpoopyWindowContext(this, window, __tempStateManager);
        __tempStateManager = null;

        __backend.createContextStage(window, __context.__viewportRect);
        __windowResize(__context);
        __context.createRenderPass();
    }

    @:noCompletion private function __windowResize(context:SpoopyWindowContext):Void {
        context.resize();
        __backend.resize(context.window, context.__viewportRect);

        //TODO: Maybe have an event system for this?
    }

    @:noCompletion private function __onWindowRender(context:RenderContext):Void { // The `RenderContext` is practically useless.
        if(__rendering) return;
        __rendering = true;

        frameCount++;

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
            SpoopyLogger.error("The window is null! Unable to create a context for module.");
            return;
        }

        window.onRender.add(__onWindowRender);
        window.onResize.add(__onWindowResize.bind(window));

        __onAddedWindow(window);

        __engine.eventModuleDispatcher.addEventListener(GraphicsEventType.UPDATE_FRAME, SpoopyEvent.ENTER_UPDATE_FRAME, __onUpdateFrame);
        __engine.eventModuleDispatcher.addEventListener(GraphicsEventType.DRAW_FRAME, SpoopyEvent.ENTER_DRAW_FRAME, __onDrawFrame);
    }

    @:noCompletion private function __unregisterWindowModule(window:Window):Void {
        __engine.eventModuleDispatcher.removeEventListener(GraphicsEventType.UPDATE_FRAME);
        __engine.eventModuleDispatcher.removeEventListener(GraphicsEventType.DRAW_FRAME);

        __context = null;
    }

    @:noCompletion private function __onUpdateFrame(event:SpoopyEvent):Void {
        
    }

    @:noCompletion private function __onDrawFrame(event:SpoopyEvent):Void {
        
    }

    @:noCompletion private function get_window():Window {
        return __context.window;
    }
}

#if spoopy_vulkan
typedef BackendGraphicsModule = spoopy.backend.native.SpoopyNativeGraphics;
#end