package spoopy.app;

import spoopy.events.SpoopyEvent;
import spoopy.events.SpoopyEventDispatcher;
import spoopy.events.SpoopyUncaughtDispatcher;
import spoopy.backend.native.SpoopyNativeEngine;
import spoopy.utils.SpoopyLogger;

import lime.app.IModule;
import lime.app.Application;


/*
* Only one instance of this class should exist.
*/
@:access(spoopy.events.SpoopyEvent)
@:access(spoopy.events.SpoopyUncaughtDispatcher)
@:access(spoopy.events.SpoopyEventDispatcher)
class SpoopyEngine implements IModule {
    public static var INSTANCE(default, null):SpoopyEngine = new SpoopyEngine();

    public var UPDATE_EVENT(default, null):SpoopyEvent;
    public var DRAW_EVENT(default, null):SpoopyEvent;

    public var cpuLimiterEnabled(default, null):Bool;
    public var updateFramerate(default, null):Float;
    public var drawFramerate(default, null):Float;
    public var timeScale(default, null):Float;

    @:noCompletion private var __eventDispatcher:SpoopyEventDispatcher;
    @:noCompletion private var __uncaughtDispatcher:SpoopyUncaughtDispatcher;
    @:noCompletion private var __thread:Dynamic;

    /*
    * The number of frames to wait before deleting a node off the queue.
    */
    public static var NUM_FRAMES_WAIT_UNTIL_DELETE(default, null):UInt = 3;

    private function new() {
        cpuLimiterEnabled = true;
        updateFramerate = 60;
        drawFramerate = 60;
    }

    public function update(updateFramerate:Float = 60, drawFramerate:Float = 60, timeScale:Float = 1.0, cpuLimiterEnabled:Bool = true) {
        this.cpuLimiterEnabled = cpuLimiterEnabled;
        this.updateFramerate = updateFramerate;
        this.drawFramerate = drawFramerate;
        this.timeScale = timeScale;

        SpoopyEngineBackend.apply(this.cpuLimiterEnabled, this.updateFramerate, this.drawFramerate, this.timeScale);
    }

    /*
    * It's important to be thread safe here, so I need to plan this out.
    */
    public inline function enableCPULimiter(value:Bool):Void {
        cpuLimiterEnabled = value;
    }

    @:noCompletion private function __registerLimeModule(application:Application):Void {
        __eventDispatcher = new SpoopyEventDispatcher();
        __uncaughtDispatcher = new SpoopyUncaughtDispatcher();

        UPDATE_EVENT = SpoopyEvent.__pool.get();
        UPDATE_EVENT.type = SpoopyEvent.ENTER_UPDATE_FRAME;

        DRAW_EVENT = SpoopyEvent.__pool.get();
        DRAW_EVENT.type = SpoopyEvent.ENTER_DRAW_FRAME;

        SpoopyNativeEngine.bindCallbacks(__update, __draw);

        #if (cpp && !cppia)
        untyped __cpp__("hx::GCPrepareMultiThreaded()");
        #end
        SpoopyNativeEngine.run();
    }

    @:noCompletion private function __unregisterLimeModule(application:Application):Void {
        SpoopyEngineBackend.shutdown();
    }

    @:noCompletion private function __update():Void {
        // __broadcastEvent(UPDATE_EVENT);
        trace("Hello World");
    }

    @:noCompletion private function __draw():Void {
        // __broadcastEvent(DRAW_EVENT);
    }

    @:noCompletion private function __broadcastEvent(event:SpoopyEvent):Void {
        if(__uncaughtDispatcher.__enabled) {
            try {
                __eventDispatcher.__dispatch(event);
            }catch(e:Dynamic) {
                __handleError(event, e);
            }
        }else {
            __eventDispatcher.__dispatch(event);
        }
    }

    @:noCompletion private function __handleError(event:SpoopyEvent, e:Dynamic):Void {
        try {
            __uncaughtDispatcher.__dispatch(event);
        }catch(e:Dynamic) {}

        if(!event.__preventThrowing) {
            SpoopyLogger.error(haxe.CallStack.toString(haxe.CallStack.exceptionStack()));
            SpoopyLogger.error(e);

            #if (cpp && !cppia)
			untyped __cpp__("throw e");
			#elseif neko
			neko.Lib.rethrow(e);
            #else
            throw e;
            #end
        }
    }
}

// TODO: If OpenGL, then have an actual backend class.
typedef SpoopyEngineBackend = SpoopyNativeEngine;

#if (cpp && !cppia)
