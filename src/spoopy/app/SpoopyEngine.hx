package spoopy.app;

import spoopy.backend.native.SpoopyNativeEngine;

import lime.app.IModule;
import lime.app.Application;

class SpoopyEngine implements IModule {
    private var cpuLimiterEnabled(default, null):Bool;

    /*
    * The number of frames to wait before deleting a node off the queue.
    */
    public static var NUM_FRAMES_WAIT_UNTIL_DELETE(default, null):UInt = 3;

    @:allow(spoopy.app.SpoopyApplication) private function new(?cpuLimiterEnabled:Bool = true) {
        this.cpuLimiterEnabled = cpuLimiterEnabled;
    }

    /*
    * It's important to be thread safe here, so I need to plan this out.
    */
    public inline function enableCPULimiter(value:Bool):Void {
        cpuLimiterEnabled = value;
    }

    @:noCompletion private function __registerLimeModule(app:Application):Void {
        SpoopyEngineBackend.main(this.cpuLimiterEnabled);
    }

    @:noCompletion private function __unregisterLimeModule(app:Application):Void {
        SpoopyEngineBackend.shutdown();
    }
}

// TODO: If OpenGL, then have an actual backend class.
typedef SpoopyEngineBackend = SpoopyNativeEngine;