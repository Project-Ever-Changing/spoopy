package spoopy.backend.native;

import spoopy.app.SpoopyEngine;
import spoopy.events.SpoopyEvent;
import sys.thread.Thread;

/*
* A wrapper class for backend Engine.
*/

@:allow(spoopy.app.SpoopyEngine)
@:allow(spoopy.backend.native.SpoopyNativeRenderTask)
class SpoopyNativeEngine {
    public static var fenceManager(default, null):SpoopyNativeFenceManager = new SpoopyNativeFenceManager();
    
    @:noCompletion private static var tasks(default, null):Array<SpoopyNativeRenderTask> = [];
    @:noCompletion private static var thread(default, null):Thread;

    @:noCompletion private static function apply(cpuLimiterEnabled:Bool, updateFramerate:Float, drawFramerate:Float, timeScale:Float):Void {
        SpoopyNativeCFFI.spoopy_engine_apply(cpuLimiterEnabled, updateFramerate, drawFramerate, timeScale);
    }

    @:noCompletion private static function bindCallbacks(updateCallback:Dynamic, drawCallback:Dynamic, syncGC:Dynamic):Void {
        SpoopyNativeCFFI.spoopy_engine_bind_callbacks(updateCallback, drawCallback, syncGC);
    }

    @:noCompletion private static function run(engine:SpoopyEngine):Void {
        thread = Thread.create(runRaw.bind(engine));
    }

    @:noCompletion private static function runRaw(engine:SpoopyEngine):Void {
        engine.UPDATE_EVENT = SpoopyEvent.__pool.get();
        engine.UPDATE_EVENT.type = SpoopyEvent.ENTER_UPDATE_FRAME;

        engine.DRAW_EVENT = SpoopyEvent.__pool.get();
        engine.DRAW_EVENT.type = SpoopyEvent.ENTER_DRAW_FRAME;

        SpoopyNativeCFFI.spoopy_engine_run_raw();
    }

    @:noCompletion private static function lockFences():Void {
        SpoopyNativeCFFI.spoopy_device_lock_fence();
    }

    @:noCompletion private static function unlockFences():Void {
        SpoopyNativeCFFI.spoopy_device_unlock_fence();
    }

    @:noCompletion private static function shutdown():Void {
        #if spoopy_debug
        spoopy.utils.SpoopyLogger.info("Shutting down engine...");
        #end

        SpoopyNativeCFFI.spoopy_engine_shutdown();
        thread = null;
    }
}