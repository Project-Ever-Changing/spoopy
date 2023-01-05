package spoopy.display;

import spoopy.SpoopyEngine;
import spoopy.backend.WindowRenderer;
import lime.ui.Window;

/*
 * Lime Window Wrapper.
 */
class SpoopyWindow {
    public var width(get, set):Int;
    public var height(get, set):Int;

    public var frameRate(get, set):Float;
    public var fullscreen(get, set):Bool;

    public var windowTitle(get, never):String;

    public var applyWindowSurface:Bool = true;

    @:noCompletion var __parent(default, set):Window;

    @:noCompletion var __renderer:WindowRenderer;

    public function new(__parent:Window) {
        this.__parent = __parent;
        __renderer = new WindowRenderer(this);
    }

    @:noCompletion private inline function get_width():Int {
        return __parent.width;
    }

    @:noCompletion private function set_width(value:Int):Int {
        __parent.resize(value, __parent.height);
        return __parent.width;
    }

    @:noCompletion private inline function get_height():Int {
        return __parent.height;
    }

    @:noCompletion private function set_height(value:Int):Int {
        __parent.resize(__parent.width, value);
        return __parent.height;
    }

    @:noCompletion private inline function get_frameRate():Float {
        return __parent.frameRate;
    }

    @:noCompletion private function set_frameRate(value:Float):Float {
        return __parent.frameRate = value;
    }

    @:noCompletion private inline function get_fullscreen():Bool {
        return __parent.fullscreen;
    }

    @:noCompletion private function set_fullscreen(value:Bool):Bool {
        return __parent.fullscreen = value;
    }

    @:noCompletion private function set___parent(window:Window):Window {
        if(applyWindowSurface && __renderer != null) {
            //__renderer.applyWindowSurface(device);
        }

        return __parent = window;
    }

    @:noCompletion private function get_windowTitle():String {
        if(__renderer != null) {
            return __renderer.getWindowTitle(__parent);
        }

        return "";
    }
}