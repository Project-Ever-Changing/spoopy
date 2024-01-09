package spoopy.backend.native;

import sys.thread.Thread;

/*
* A wrapper class for backend Engine.
*/

@:allow(spoopy.app.SpoopyEngine)
@:allow(spoopy.backend.native.SpoopyNativeRenderTask)
class SpoopyNativeEngine {
    public static var fenceManager(default, null):SpoopyNativeFenceManager = new SpoopyNativeFenceManager();
    
    @:noCompletion private static var tasks(default, null):Array<SpoopyNativeRenderTask> = [];

    @:noCompletion private static function apply(cpuLimiterEnabled:Bool, updateFramerate:Float, drawFramerate:Float, timeScale:Float):Void {
        SpoopyNativeCFFI.spoopy_engine_apply(cpuLimiterEnabled, updateFramerate, drawFramerate, timeScale);
    }

    @:noCompletion private static function bindCallbacks(updateCallback:Dynamic, drawCallback:Dynamic):Void {
        SpoopyNativeCFFI.spoopy_engine_bind_callbacks(updateCallback, drawCallback);
    }

    @:noCompletion private static function run():Void {
        Thread.create(runRaw);
    }

    @:noCompletion private static function runRaw():Void {
        SpoopyNativeCFFI.spoopy_engine_run_raw();
    }

    @:noCompletion private static function lockFences():Void {
        SpoopyNativeCFFI.spoopy_device_lock_fence();
    }

    @:noCompletion private static function unlockFences():Void {
        SpoopyNativeCFFI.spoopy_device_unlock_fence();
    }

    @:noCompletion private static function shutdown():Void {
        // shutdown
    }
}