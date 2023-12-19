package spoopy.backend.native;

/*
* A wrapper class for backend Engine.
*/
@:allow(spoopy.app.SpoopyEngine)
class SpoopyNativeEngine {
    @:noCompletion private static function main(cpuLimiterEnabled:Bool, updateCallback:Void->Void, renderCallback:Void->Void) {
        SpoopyNativeCFFI.spoopy_engine_main(cpuLimiterEnabled, updateCallback, renderCallback);
    }

    @:noCompletion private static function apply(updateFramerate:Float, drawFramerate:Float, timeScale:Float):Void {
        SpoopyNativeCFFI.spoopy_engine_apply(updateFramerate, drawFramerate, timeScale);
    }

    @:noCompletion private static function dequire():Void {
        SpoopyNativeCFFI.spoopy_engine_dequeue();
    }

    @:noCompletion private static function shutdown() {
        // shutdown
    }
}