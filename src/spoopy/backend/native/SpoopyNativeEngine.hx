package spoopy.backend.native;

/*
* A wrapper class for backend Engine.
*/
@:allow(spoopy.app.SpoopyEngine)
class SpoopyNativeEngine {
    @:noCompletion private static function apply(cpuLimiterEnabled:Bool, updateFramerate:Float, drawFramerate:Float, timeScale:Float):Void {
        SpoopyNativeCFFI.spoopy_engine_apply(cpuLimiterEnabled, updateFramerate, drawFramerate, timeScale);
    }

    @:noCompletion private static function bindCallbacks(updateCallback:Dynamic, drawCallback:Dynamic):Void {
        SpoopyNativeCFFI.spoopy_engine_bind_callbacks(updateCallback, drawCallback);
    }

    @:noCompletion private static function shutdown() {
        // shutdown
    }
}