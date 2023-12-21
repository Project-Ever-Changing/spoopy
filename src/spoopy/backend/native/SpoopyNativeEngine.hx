package spoopy.backend.native;

/*
* A wrapper class for backend Engine.
*/

#if cpp
@:headerCode("#include <hx/Thread.h>")
#end

@:allow(spoopy.app.SpoopyEngine)
class SpoopyNativeEngine {
    @:noCompletion private static var __semaphore:SpoopyNativeSemaphore = new SpoopyNativeSemaphore();

    @:noCompletion private static function apply(cpuLimiterEnabled:Bool, updateFramerate:Float, drawFramerate:Float, timeScale:Float):Void {
        SpoopyNativeCFFI.spoopy_engine_apply(cpuLimiterEnabled, updateFramerate, drawFramerate, timeScale);
    }

    @:noCompletion private static function bindCallbacks(updateCallback:Dynamic, drawCallback:Dynamic):Void {
        SpoopyNativeCFFI.spoopy_engine_bind_callbacks(updateCallback, drawCallback);
    }

    @:noCompletion private static function run():Void {
        SpoopyNativeCFFI.spoopy_engine_run();
    }

    @:noCompletion private static function runRaw(arg:SpoopyThread):SpoopyThread {
        //SpoopyNativeCFFI.spoopy_engine_run_raw();
        //trace("hello world");

        __semaphore.set();
        untyped __cpp__('printf("%s\n", "hello world")');
        return null;
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