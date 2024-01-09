package spoopy.app;

import spoopy.events.SpoopyEvent;
import spoopy.events.SpoopyEventDispatcher;
import spoopy.events.SpoopyUncaughtDispatcher;
import spoopy.graphics.descriptor.SpoopyDescriptorManager;
import spoopy.graphics.SpoopyGraphicsModule;
import spoopy.graphics.SpoopyWindowContext;
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

    public var descriptorManager(default, null):SpoopyDescriptorManager;

    public var UPDATE_EVENT(default, null):SpoopyEvent;
    public var DRAW_EVENT(default, null):SpoopyEvent;

    public var cpuLimiterEnabled(default, null):Bool;
    public var updateFramerate(default, null):Int;
    public var drawFramerate(default, null):Int;
    public var timeScale(default, null):Float;
    public var frameCounter(default, null):Float;

    public var eventDispatcher(default, null):SpoopyEventDispatcher<String>;
    public var uncaughtDispatcher(default, null):SpoopyUncaughtDispatcher<String>;

    @:allow(spoopy.graphics.SpoopyGraphicsModule) private var eventModuleDispatcher(default, null):SpoopyEventDispatcher<GraphicsEventType>;
    @:allow(spoopy.graphics.SpoopyGraphicsModule) private var uncaughtModuleDispatcher(default, null):SpoopyUncaughtDispatcher<GraphicsEventType>;

    @:noCompletion private var __isRendering:Bool;

    /*
    * The number of frames to wait before deleting a node off the queue.
    */
    public static var NUM_FRAMES_WAIT_UNTIL_DELETE(default, null):UInt = 3;

    /*
    * The max amount of back buffers that can be stored into a Haxe Vector.
    */
    public static var MAX_BACK_BUFFERS(default, null):UInt = 4;

    private function new() {
        __isRendering = false;
        cpuLimiterEnabled = true;
        updateFramerate = 60;
        drawFramerate = 60;
        frameCounter = 0;
    }

    public function update(updateFramerate:Int = 60, drawFramerate:Int = 60, timeScale:Float = 1.0, cpuLimiterEnabled:Bool = true) {
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

    @:allow(spoopy.graphics.SpoopyGraphicsModule) private inline function createRenderTask(context:SpoopyWindowContext):Void {
        SpoopyEngineBackend.createTask();
    }

    @:noCompletion private function __registerLimeModule(application:Application):Void {
        eventDispatcher = new SpoopyEventDispatcher<String>();
        uncaughtDispatcher = new SpoopyUncaughtDispatcher<String>();

        eventModuleDispatcher = new SpoopyEventDispatcher<GraphicsEventType>();
        uncaughtModuleDispatcher = new SpoopyUncaughtDispatcher<GraphicsEventType>();

        UPDATE_EVENT = SpoopyEvent.__pool.get();
        UPDATE_EVENT.type = SpoopyEvent.ENTER_UPDATE_FRAME;

        DRAW_EVENT = SpoopyEvent.__pool.get();
        DRAW_EVENT.type = SpoopyEvent.ENTER_DRAW_FRAME;

        SpoopyEngineBackend.bindCallbacks(__update, __draw);
        SpoopyEngineBackend.run();

        descriptorManager = new SpoopyDescriptorManager();
    }

    @:noCompletion private function __unregisterLimeModule(application:Application):Void {
        eventDispatcher = null;
        uncaughtDispatcher = null;

        eventModuleDispatcher = null;
        uncaughtModuleDispatcher = null;

        SpoopyEngineBackend.shutdown();
    }

    @:noCompletion private function __update():Void {
        __broadcastEvent(UPDATE_EVENT, eventModuleDispatcher, uncaughtModuleDispatcher);
        __broadcastEvent(UPDATE_EVENT, eventDispatcher, uncaughtDispatcher);
    }

    @:noCompletion private function __draw():Void {
        if(__isRendering) return;
        __isRendering = true;

        __broadcastEvent(DRAW_EVENT, eventModuleDispatcher, uncaughtModuleDispatcher);
        __broadcastEvent(DRAW_EVENT, eventDispatcher, uncaughtDispatcher);

        __isRendering = false;
    }

    @:noCompletion private function __broadcastEvent<T:String>(event:SpoopyEvent, dispatcher:SpoopyEventDispatcher<T>, uncaught:SpoopyUncaughtDispatcher<T>):Void {
        if(uncaughtDispatcher.__enabled) {
            try {
                eventDispatcher.__dispatch(event);
            }catch(e:Dynamic) {
                __handleError(event, e);
            }
        }else {
            eventDispatcher.__dispatch(event);
        }
    }

    @:noCompletion private function __handleError(event:SpoopyEvent, e:Dynamic):Void {
        try {
            uncaughtDispatcher.__dispatch(event);
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
#if spoopy_vulkan
typedef SpoopyEngineBackend = spoopy.backend.native.SpoopyNativeEngine;
#end