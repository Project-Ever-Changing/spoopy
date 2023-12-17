package spoopy.app;

import spoopy.events.SpoopyEvent;
import spoopy.events.SpoopyEventDispatcher;
import spoopy.backend.native.SpoopyNativeEngine;
import spoopy.utils.SpoopyLogger;

import lime.app.IModule;
import lime.app.Application;


/*
* Only one instance of this class should exist.
*/
@:access(spoopy.events.SpoopyEvent)
@:access(spoopy.events.SpoopyUncaughtDispatcher)
class SpoopyEngine implements IModule {
    public static var INSTANCE(default, null):SpoopyEngine = new ;

    public var UPDATE_EVENT(default, null):SpoopyEvent;
    public var DRAW_EVENT(default, null):SpoopyEvent;

    private var cpuLimiterEnabled(default, null):Bool;

    @:noCompletion private var __eventDispatcher:SpoopyEventDispatcher;
    @:noCompletion private var __uncaughtDispatcher:SpoopyUncaughtDispatcher;

    /*
    * The number of frames to wait before deleting a node off the queue.
    */
    public static var NUM_FRAMES_WAIT_UNTIL_DELETE(default, null):UInt = 3;

    private function new() {}

    public function init(updateFPS:Float = 60, drawFPS:Float = 60, cpuLimiterEnabled:Bool = true) {
        this.cpuLimiterEnabled = cpuLimiterEnabled;

        __eventDispatcher = new SpoopyEventDispatcher();
        __uncaughtDispatcher = new SpoopyUncaughtDispatcher();

        UPDATE_EVENT = SpoopyEvent.__pool.get();
        UPDATE_EVENT.type = SpoopyEvent.ENTER_UPDATE_FRAME;

        DRAW_EVENT = SpoopyEvent.__pool.get();
        DRAW_EVENT.type = SpoopyEvent.ENTER_DRAW_FRAME;
    }

    /*
    * It's important to be thread safe here, so I need to plan this out.
    */
    public inline function enableCPULimiter(value:Bool):Void {
        cpuLimiterEnabled = value;
    }

    @:noCompletion private function __registerLimeModule(app:Application):Void {
        SpoopyEngineBackend.main(this.cpuLimiterEnabled, __update, __draw);


    }

    @:noCompletion private function __unregisterLimeModule(app:Application):Void {
        SpoopyEngineBackend.shutdown();
    }

    @:noCompletion private function __update():Void {
        __broadcastEvent(UPDATE_EVENT);
    }

    @:noCompletion private function __draw():Void {
        __broadcastEvent(DRAW_EVENT);
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

        if(event.__preventThrowing) {
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