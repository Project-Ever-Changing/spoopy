package spoopy.app;

import spoopy.backend.native.SpoopyNativeEngine;

import lime.app.IModule;
import lime.app.Application;

class SpoopyEngine implements IModule {
    public var cpuLimiterEnabled(default, set);

    /*
    * The number of frames to wait before deleting a node off the queue.
    */
    public static var NUM_FRAMES_WAIT_UNTIL_DELETE(default, null):UInt = 3;

    @:allow(spoopy.app.SpoopyApplication) private function new(?cpuLimiterEnabled:Bool = true) {
        this.cpuLimiterEnabled = cpuLimiterEnabled;
    }

    @:noCompletion private function __registerLimeModule(app:Application):Bool {
        SpoopyEngineBackend.main(this.cpuLimiterEnabled);
    }

    @:noCompletion private function __unregisterLimeModule(app:Application):Bool {
        SpoopyEngineBackend.shutdown();
    }

    /*
    * It's important to be thread safe here, so I need to plan this out.
    */
    @:noCompletion private function set_cpuLimiterEnabled(value:Bool):Bool {
        return cpuLimiterEnabled = value;
    }
}

// TODO: If OpenGL, then have an actual backend class.
typedef SpoopyEngineBackend = SpoopyNativeEngine;