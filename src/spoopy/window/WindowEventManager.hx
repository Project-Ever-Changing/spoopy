package spoopy.window;

import spoopy.ui.SpoopyKeyboardAttributes;
import spoopy.ui.SpoopyMouseMode;
import spoopy.ui.SpoopyKeyMode;

import lime.graphics.RenderContext;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.MouseWheelMode;
import lime.ui.Window;

import openfl.ui.Keyboard;
import openfl.ui.KeyLocation;

@:access(openfl.ui.Keyboard)
@:access(spoopy.ui.SpoopyKeyboardAttributes)
class WindowEventManager implements IWindowModule {
    public var window(default, null):Window;

    /*
    * If an input event is triggered, it wouldn't trigger with the window is out of focus.
    */
    public var enableWindowFocus:Bool = true;

    /*
    * Check if the window is in focus.
    */
    public var windowFocus(get, never):Bool;

    /*
    * Get the X position of the mouse.
    */
    public var mouseX(get, never):Float;

    /*
    * Get the Y position of the mouse.
    */
    public var mouseY(get, never):Float;

    /*
    * Get if mouse is held on window.
    */
    public var mouseDown(get, never):Bool;

    /*
    * Should resize the render display everytime the window is resized.
    */
    public var updateDisplaySize:Bool = false;

    /*
    * `framerate` for the application window, in frames per second.
    */
    public var frameRate(get, set):Float;

    #if spoopy_track_render_calls

    /*
    * How many times the window has been rendered.
    */
    public var trackedRenderCalls:Int = 0;

    #end
    

    @:noCompletion private var __rendering:Bool;
    @:noCompletion private var __fullscreen:Bool;
    @:noCompletion private var __windowFocus:Bool;
    @:noCompletion private var __keysHeld:Array<KeyCode>;
    @:noCompletion private var __mouseX:Float;
    @:noCompletion private var __mouseY:Float;
    @:noCompletion private var __mouseDown:Bool;

    public function new() {
        __keysHeld = new Array<KeyCode>();

        __mouseX = 0;
        __mouseY = 0;
    }

    public function getKeyHeld(key:KeyCode):Bool {
        return #if (haxe >= "4.0.0") __keysHeld.contains(key); #else return __keysHeld.indexOf(key) > -1; #end
    }

    private function onWindowUpdate():Void {}
    private function onWindowActivate():Void {}
    private function onWindowClose():Void {}
    private function onWindowDeactivate():Void {}
    private function onWindowDropFile(window:Window, file:String):Void {}
    private function onWindowEnter(window:Window):Void {}
    private function onWindowExpose():Void {}
    private function onWindowFocusIn():Void {}
    private function onWindowFocusOut():Void {}
    private function onWindowChangedSize(width:Int, height:Int):Void {}
    private function onWindowFullscreen(fullscreen:Bool):Void {}
    private function onWindowKey(keyMode:SpoopyKeyMode, charCode:Int, keyCode:Int, keyLocation:KeyLocation):Void {}
    private function onWindowLeave():Void {}
    private function onWindowMinimized():Void {}
    private function onWindowMouseDown(mouseMode:SpoopyMouseMode, x:Float, y:Float):Void {}
    private function onWindowMouseUp(mouseMode:SpoopyMouseMode, x:Float, y:Float):Void {}
    private function onWindowMouseMove(x:Float, y:Float):Void {}
    private function onWindowMouseMoveRelative(x:Float, y:Float):Void {}
    private function onWindowMouseWheel(x:Float, y:Float, delta:Int):Void {}
    private function onWindowMove(x:Float, y:Float):Void {}

    /*
    * General gist of how everything works.
    */

    @:noCompletion private function __onWindowRender(context:RenderContext):Void {
        if(__rendering) return;
        __rendering = true;

        onWindowUpdate();
        
        #if spoopy_track_render_calls
        trackedRenderCalls++;
        #end

        __rendering = false;
    }

    @:noCompletion private function __onWindowActivate(window:Window):Void {
        if(this.window == null || this.window != window) {
            return;
        }

        onWindowActivate();
    }

    @:noCompletion private function __onWindowClose(window:Window):Void {
        if(this.window == window) {
            this.window = null;
        }

        onWindowClose();
    }

    @:noCompletion private function __onWindowDeactivate(window:Window):Void {
        if(this.window == null || this.window != window) {
            return;
        }

        onWindowDeactivate();
    }

    @:noCompletion private function __onWindowExpose(window:Window):Void {
        if(this.window == null || this.window != window) {
            return;
        }

        onWindowExpose();
    }

    @:noCompletion private function __onWindowFocusIn(window:Window):Void {
        if(this.window == null || this.window != window) {
            return;
        }

        __windowFocus = true;
        onWindowFocusIn();
    }

    @:noCompletion private function __onWindowFocusOut(window:Window):Void {
        if(this.window == null || this.window != window) {
            return;
        }

        __windowFocus = false;
        onWindowFocusOut();

        SpoopyKeyboardAttributes.__altKey = false;
        SpoopyKeyboardAttributes.__commandKey = false;
        SpoopyKeyboardAttributes.__ctrlKey = false;
        SpoopyKeyboardAttributes.__shiftKey = false;
    }

    @:noCompletion private function __onWindowFullscreen(window:Window):Void {
        if(this.window == null || this.window != window) {
            return;
        }

        onWindowChangedSize(window.width, window.height);

        if(!__fullscreen) {
            __fullscreen = true;
            onWindowFullscreen(true);
        }
    }

    @:noCompletion private function __onKey(keyMode:SpoopyKeyMode, keyCode:KeyCode, modifier:KeyModifier):Void {
        SpoopyKeyboardAttributes.__altKey = modifier.altKey;
        SpoopyKeyboardAttributes.__commandKey = modifier.metaKey;
        SpoopyKeyboardAttributes.__ctrlKey = modifier.ctrlKey;
        SpoopyKeyboardAttributes.__shiftKey = modifier.shiftKey;

        var keyLocation = Keyboard.__getKeyLocation(keyCode);
		var keyCode = Keyboard.__convertKeyCode(keyCode);
		var charCode = Keyboard.__getCharCode(keyCode, modifier.shiftKey);

        if(!__windowFocus && enableWindowFocus) {
            return;
        }

        #if (haxe >= "4.0.0")
        if(!__keysHeld.contains(keyCode)) {
            __keysHeld.push(keyCode);
        }
        #else
        if(__keysHeld.indexOf(keyCode) == -1) {
            __keysHeld.push(keyCode);
        }
        #end

        onWindowKey(keyMode, charCode, keyCode, keyLocation);

        if(keyMode == KEY_DOWN) {
            window.onKeyDown.cancel();
        }else {
            window.onKeyUp.cancel();
        }
    }

    @:noCompletion private function __onWindowKeyDown(window:Window, keyCode:KeyCode, modifier:KeyModifier):Void {
        if(this.window == null || this.window != window) {
            return;
        }

        __onKey(KEY_DOWN, keyCode, modifier);
    }

    @:noCompletion private function __onWindowKeyUp(window:Window, keyCode:KeyCode, modifier:KeyModifier):Void {
        if(this.window == null || this.window != window) {
            return;
        }

        __onKey(KEY_UP, keyCode, modifier);
    }

    @:noCompletion private function __onWindowLeave(window:Window):Void {
        if(this.window == null || this.window != window || __mouseDown) {
            return;
        }

        onWindowLeave();
    }

    @:noCompletion private function __onWindowMinimized(window:Window):Void {
        if(this.window == null || this.window != window) {
            return;
        }

        onWindowMinimized();
    }

    @:noCompletion private function __onWindowMouseDown(window:Window, x:Float, y:Float, button:Int):Void {
        if(this.window == null || this.window != window || button > 2) {
            return;
        }

        if(button > 2) {
            return;
        }

        var mouseMode = switch(button) {
            case 1: SpoopyMouseMode.MIDDLE_MOUSE;
            case 2: SpoopyMouseMode.RIGHT_MOUSE;
            default: SpoopyMouseMode.MOUSE;
        }

        __mouseX = x;
        __mouseY = y;

        __mouseDown = true;

        onWindowMouseDown(mouseMode, x, y);

        if(button == 2) {
            window.onMouseDown.cancel();
        }
    }

    @:noCompletion private function __onWindowMouseUp(window:Window, x:Float, y:Float, button:Int):Void {
        if(this.window == null || this.window != window || button > 2) {
            return;
        }

        if(button > 2) {
            return;
        }

        var mouseMode = switch(button) {
            case 1: SpoopyMouseMode.MIDDLE_MOUSE;
            case 2: SpoopyMouseMode.RIGHT_MOUSE;
            default: SpoopyMouseMode.MOUSE;
        }

        __mouseX = x;
        __mouseY = y;

        __mouseDown = false;

        onWindowMouseUp(mouseMode, x, y);

        if(button == 2) {
            window.onMouseUp.cancel();
        }
    }

    @:noCompletion private function __onWindowMouseMove(window:Window, x:Float, y:Float):Void {
        if(this.window == null || this.window != window) {
            return;
        }

        __mouseX = x;
        __mouseY = y;

        onWindowMouseMove(x, y);
    }

    @:noCompletion private function __onWindowMouseMoveRelative(window:Window, x:Float, y:Float):Void {
        if(this.window == null || this.window != window) {
            return;
        }

        onWindowMouseMoveRelative(x, y);
    }

    @:noCompletion private function __onWindowMouseWheel(window:Window, deltaX:Float, deltaY:Float, deltaMode:MouseWheelMode):Void {
        if(this.window == null || this.window != window) {
            return;
        }

        var delta:Int = Std.int(deltaY);

        onWindowMouseWheel(__mouseX, __mouseY, delta);
    }

    @:noCompletion private function __onWindowMove(window:Window, x:Float, y:Float):Void {
        if(this.window == null || this.window != window) {
            return;
        }

        onWindowMove(x, y);
    }

    @:noCompletion private function __onWindowResize(window:Window, width:Int, height:Int):Void {
        if(this.window == null || this.window != window) {
            return;
        }

        if(__fullscreen && window.fullscreen) {
            __fullscreen = false;
            onWindowFullscreen(false);
        }else if(updateDisplaySize) {
            onWindowChangedSize(width, height);
        }
    }

    @:noCompletion private function __onWindowRestore(window:Window):Void {
        if(this.window == null || this.window != window) {
            return;
        }

        if(__fullscreen && !window.fullscreen) {
            __fullscreen = false;
            onWindowFullscreen(false);
        }
    }

    @:noCompletion private function __registerWindowModule(window:Window):Void {
        if(this.window != window) return;

        this.window = window;

        window.onActivate.add(__onWindowActivate.bind(window));
        window.onClose.add(__onWindowClose.bind(window), false, -9000);
        window.onDeactivate.add(__onWindowDeactivate.bind(window));
        window.onDropFile.add(onWindowDropFile.bind(window));
        window.onEnter.add(onWindowEnter.bind(window));
        window.onExpose.add(__onWindowExpose.bind(window));
        window.onFocusIn.add(__onWindowFocusIn.bind(window));
        window.onFocusOut.add(__onWindowFocusOut.bind(window));
        window.onFullscreen.add(__onWindowFullscreen.bind(window));
        window.onKeyDown.add(__onWindowKeyDown.bind(window));
        window.onKeyUp.add(__onWindowKeyUp.bind(window));
        window.onLeave.add(__onWindowLeave.bind(window));
        window.onMinimize.add(__onWindowMinimized.bind(window));
        window.onMouseDown.add(__onWindowMouseDown.bind(window));
        window.onMouseMove.add(__onWindowMouseMove.bind(window));
        window.onMouseMoveRelative.add(__onWindowMouseMoveRelative.bind(window));
        window.onMouseWheel.add(__onWindowMouseWheel.bind(window));
        window.onMove.add(__onWindowMove.bind(window));
        window.onResize.add(__onWindowResize.bind(window));
        window.onRestore.add(__onWindowRestore.bind(window));

        window.onRender.add(__onWindowRender);
    }

    @:noCompletion private function __unregisterWindowModule(window:Window):Void {
        this.window = null;
    }

    /*
    * Getter Functions.
    */
    @:noCompletion private function get_windowFocus():Bool {
        return __windowFocus;
    }

    @:noCompletion private function get_mouseX():Float {
        return __mouseX;
    }

    @:noCompletion private function get_mouseY():Float {
        return __mouseY;
    }

    @:noCompletion private function get_mouseDown():Bool {
        return __mouseDown;
    }

    @:noCompletion private function get_frameRate():Float {
        if(window != null) {
            return window.frameRate;
        }

        return 0;
    }

    /*
    * Setter Functions.
    */
    @:noCompletion private function set_frameRate(value:Float):Float {
        if(window != null) {
            return window.frameRate = value;
        }

        return value;
    }
}