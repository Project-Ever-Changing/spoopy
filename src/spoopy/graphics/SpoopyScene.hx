package spoopy.graphics;

import spoopy.state.SpoopyState;
import spoopy.app.SpoopyApplication;
import spoopy.frontend.storage.SpoopyCameraStorage;
import spoopy.frontend.storage.SpoopyShaderStorage;
import spoopy.graphics.other.SpoopySwapChain;
import spoopy.rendering.command.SpoopyCommand;

import lime.ui.Window;
import lime.utils.Log;

class SpoopyScene extends SpoopySwapChain {
    public var cameras(default, null):SpoopyCameraStorage;
    public var shaders(default, null):SpoopyShaderStorage;

    public var ticks(default, null):Int = 0;
    public var elapsed(default, null):Float = 0;
    public var maxElapsed:Float = 0.1;
    public var timeScale:Float = 1;

    public var fullscreen(get, set):Bool;

    public var state(default, null):SpoopyState;

    public var fixedTimestep:Bool = true;
    public var autoPause:Bool = false;

    public var updateFramerate(default, set):Int;
    public var renderFramerate(default, set):Int;

    @:noCompletion var __nextState:SpoopyState;
    @:noCompletion var __commandQueue:Array<SpoopyCommand>;

    @:noCompletion var __initialize:Bool;
    @:noCompletion var __fullscreenDirty:Bool;
    @:noCompletion var __drawOnCommandDirty:Bool;
    @:noCompletion var __focusDirty:Bool;
    @:noCompletion var __focusLost:Bool;

    @:noCompletion var __acumulator:Float;
    @:noCompletion var __maxAccumulation:Float;
    @:noCompletion var __stepSeconds:Float;
    @:noCompletion var __stepMS:Float;
    @:noCompletion var __totalTime:Float;
    @:noCompletion var __elapsedMS:Float;
    @:noCompletion var __startTime:Int;

    public function new(application:SpoopyApplication, fullscreen:Bool = false, ?initState:SpoopyState = null) {
        super(application);

        cameras = new SpoopyCameraStorage(this);
        shaders = new SpoopyShaderStorage(this);

        __fullscreenDirty = fullscreen;
        __acumulator = __stepMS;

        state = (initState == null) ? new SpoopyState() : initState;
        state.device = this;

        __nextState = state;
    }

    public function switchState<T:SpoopyState>(nextState:SpoopyState):Void {
        if(state.switchTo(nextState)) {
            return;
        }

        __nextState = nextState;
        __nextState.device = this;
    }

    public function addCommandToQueue(command:SpoopyCommand):Void {
        __commandQueue.insert(0, command);
    }

    private function processSwitch():Void {
        cameras.reset();

        if(state != null) {
            state.destroy();
        }

        state = __nextState;
        state.create();
    }

    private function update():Void {
        if(!state.active || !state.inScene) {
            return;
        }

        if(state != __nextState) {
            processSwitch();
        }

        if(fixedTimestep) {
            elapsed = timeScale * __stepSeconds;
        }else {
            elapsed = timeScale * (__elapsedMS * 0.001);

            var maxTime = maxElapsed * timeScale;

            if(elapsed > maxTime) {
                elapsed = maxTime;
            }
        }

        state.update(elapsed);
        cameras.update(elapsed);
    }

    private function render():Void {
        if(!state.visible || !state.inScene) {
            return;
        }

        cameras.render();
        state.render();

        while(__commandQueue.length > 0) {
            drawBasedOnCommand(__commandQueue[0]);
            __commandQueue.shift();
        }
    }

    override function create():Void {
        super.create();

        if(__initialize) {
            return;
        }

        __initialize = true;
        __startTime = SpoopyApplication.getTimer();
        __totalTime = getTicks();

        #if desktop
        fullscreen = __fullscreenDirty;
        #end

        frameRate = renderFramerate;
    }

    override function beginRenderPass():Void {
        super.beginRenderPass();
        cameras.beginRenderPass();
        shaders.bind();
    }

    #if desktop
    override function onWindowFocusIn():Void {
        super.onWindowFocusIn();

        if(!__focusDirty) {
            __focusDirty = true;
            return;
        }

        __focusLost = false;
    }

    override function onWindowFocusOut():Void {
        super.onWindowFocusOut();
        __focusLost = true;
    }
    #end

    override function onUpdate():Void {
        super.onUpdate();

        ticks = getTicks();
        __elapsedMS = ticks - __totalTime;
        __totalTime = ticks;

        if(__focusLost && autoPause) {
            return;
        }

        if(fixedTimestep) {
            __acumulator += __elapsedMS;
            __acumulator = (__acumulator > __maxAccumulation) ? __maxAccumulation : __acumulator;

            while(__acumulator >= __stepMS) {
                update();
                __acumulator -= __stepMS;
            }
        }else {
            update();
        }

        render();
    }

    @:noCompletion override private function __registerWindowModule(window:Window):Void {
        #if spoopy_debug
        Log.info("Window's framerate is set to " + frameRate + " fps.");
        #end

        super.__registerWindowModule(window);

        updateFramerate = Std.int(frameRate);
        renderFramerate = Std.int(frameRate);
    }

    @:noCompletion function get_fullscreen():Bool {
        return __fullscreenDirty;
    }

    @:noCompletion function set_fullscreen(value:Bool):Bool {
        if(window == null) {
            return __fullscreenDirty;
        }

        if(value && !window.fullscreen) {
            window.fullscreen = true;
        }else if(!value && window.fullscreen) {
            window.fullscreen = false;
        }

        return __fullscreenDirty = value;
    }

    @:noCompletion function set_updateFramerate(value:Int):Int {
        value = Std.int(Math.abs(value));

        if(value < renderFramerate) {
            Log.warn("Be careful when prioritizing the update framerate over the render framerate, as this can result in a choppy or laggy user experience.");
        }

        updateFramerate = value;

        __stepMS = Math.abs(1000 / value);
        __stepSeconds = __stepMS * 0.001;

        if(__maxAccumulation < __stepMS) {
            __maxAccumulation = __stepMS;
        }

        return value;
    }

    @:noCompletion function set_renderFramerate(value:Int):Int {
        value = Std.int(Math.abs(value));

        if(value > updateFramerate) {
            Log.warn("Be careful when prioritizing the update framerate over the render framerate, as this can result in a choppy or laggy user experience.");
        }

        renderFramerate = value;
        frameRate = renderFramerate;

        __maxAccumulation = 2000 / renderFramerate - 1;

        if(__maxAccumulation < __stepMS) {
            __maxAccumulation = __stepMS;
        }

        return value;
    }

    inline function getTicks():Int {
        return SpoopyApplication.getTimer() - __startTime;
    }
}