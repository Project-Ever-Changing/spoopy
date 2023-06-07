package spoopy.app.graphics;

import spoopy.backend.native.SpoopyNativeCFFI;
import lime.app.IModule;
import lime.app.Application;

class SpoopyGraphicsModule implements IModule {
    @:noCompletion private var __deltaTime:Int;
    @:noCompletion private var __backend:BackendGraphicsModule;

    public function new() {
        __deltaTime = 0;

        __backend = new BackendGraphicsModule();
    }

    @:noCompletion private function __onUpdate(deltaTime:Int):Void {
        __deltaTime = deltaTime;

        SpoopyNativeCFFI.spoopy_update_graphics_module();

        // TODO: Add an event system that will have inputs/events.
    }

    @:noCompletion private function __onModuleExit(code:Int):Void {
        // TODO: Dispatch anything in the future.
    }

    @:noCompletion private function __registerLimeModule(application:Application):Void {
        application.onUpdate.add(__onUpdate);
        application.onExit.add(__onModuleExit);
    }

    @:noCompletion private function __unregisterLimeModule(application:Application):Void {
        application.onUpdate.remove(__onUpdate);
		application.onExit.remove(__onModuleExit);
    }
}

#if spoopy_vulkan
typedef BackendGraphicsModule = spoopy.backend.native.SpoopyNativeGraphics;
#end