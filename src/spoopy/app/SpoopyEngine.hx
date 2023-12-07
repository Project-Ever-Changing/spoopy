package spoopy.app;

import spoopy.backend.native.SpoopyNativeEngine;
import lime.app.IModule;

class SpoopyEngine implements IModule {
    public var cpuLimiterEnabled(default, set);

    /*
    * The number of frames to wait before deleting a node off the queue.
    */
    public static inline var NUM_FRAMES_WAIT_UNTIL_DELETE(default, null):UInt = 3;

    @:allow(spoopy.app.SpoopyApplication) private function new(?cpuLimiterEnabled:Bool = true) {
        this.cpuLimiterEnabled = cpuLimiterEnabled;
        
        SpoopyEngineBackend.main(this.cpuLimiterEnabled);
    }

    /*
    * It's important to be thread safe here, so I need to plan this out.
    */
    @:noCompletion private inline function set_cpuLimiterEnabled(value:Bool):Bool {
        return cpuLimiterEnabled = value;
    }
}

// TODO: If OpenGL, then have an actual backend class.
typedef SpoopyEngineBackend = SpoopyNativeEngine;