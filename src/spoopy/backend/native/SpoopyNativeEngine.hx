package spoopy.backend.native;

/*
* A wrapper class for backend Engine.
*/
@:allow(spoopy.app.SpoopyEngine)
class SpoopyNativeEngine {
    @:noCompletion private static function main(cpuLimiterEnabled:Bool, updateCallback:Void->Void, renderCallback:Void->Void) {
        SpoopyNativeCFFI.spoopy_engine_main(cpuLimiterEnabled, updateCallback, renderCallback);
    }

    @:noCompletion private static function shutdown() {
        // shutdown
    }
}