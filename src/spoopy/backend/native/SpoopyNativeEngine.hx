package spoopy.backend.native;

/*
* A wrapper class for backend Engine.
*/

#if cpp
@:headerCode("#include <hx/Thread.h>")
#end

@:allow(spoopy.app.SpoopyEngine)
class SpoopyNativeEngine {
    public static var __semaphore:SpoopyNativeSemaphore = new SpoopyNativeSemaphore();

    @:noCompletion private static function apply(cpuLimiterEnabled:Bool, updateFramerate:Float, drawFramerate:Float, timeScale:Float):Void {
        SpoopyNativeCFFI.spoopy_engine_apply(cpuLimiterEnabled, updateFramerate, drawFramerate, timeScale);
    }

    @:noCompletion private static function bindCallbacks(updateCallback:Dynamic, drawCallback:Dynamic):Void {
        SpoopyNativeCFFI.spoopy_engine_bind_callbacks(updateCallback, drawCallback);
    }

    @:noCompletion private static function run():Void {
        SpoopyNativeCFFI.spoopy_engine_run();
    }

    @:noDebug @:noCompletion private static function runRaw(arg:SpoopyThread):SpoopyThread {
        //SpoopyNativeCFFI.spoopy_engine_run_raw();
        untyped __cpp__('hx::RegisterCurrentThread(nullptr);');
        oops();
        untyped __cpp__('hx::UnregisterCurrentThread();');
        return null;
    }

    @:noCompletion private static function oops():Void {
        trace("hello world");
    }

    @:noCompletion private static function shutdown():Void {
        // shutdown
    }
}

#if cpp
typedef SpoopyThread = spoopy.backend.native.cpp.SpoopyNativeThread.ThreadFunctionType;
#else
typedef SpoopyThread = Int;
#end