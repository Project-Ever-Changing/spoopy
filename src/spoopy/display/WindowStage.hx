package spoopy.display;

import lime.ui.Window;

import spoopy.SpoopyEngine;
import spoopy.backend.WindowRenderer;

/*
 * Handles anything having to do window related so the game doesn't have too.
 */
class WindowStage {
    var parent(default, set):Window;

    public var width(get, set):Int;
    public var height(get, set):Int;

    public var frameRate(get, set):Float;
    public var fullscreen(get, set):Bool;

    public var applyWindowSurface:Bool = true;

    @:noCompletion var __renderer:WindowRenderer;

    public function new(parent:Window) {
        this.parent = parent;
        renderer = new WindowRenderer(this);
    }

    @:noCompletion private inline function get_width():Int {
        return parent.width;
    }

    @:noCompletion private function set_width(value:Int):Int {
        parent.resize(value, parent.height);
        return parent.width;
    }

    @:noCompletion private inline function get_height():Int {
        return parent.height;
    }

    @:noCompletion private function set_height(value:Int):Int {
        parent.resize(parent.width, value);
        return parent.height;
    }

    @:noCompletion private inline function get_frameRate():Float {
        return parent.frameRate;
    }

    @:noCompletion private function set_frameRate(value:Float):Float {
        return parent.frameRate = value;
    }

    @:noCompletion private inline function get_fullscreen():Bool {
        return parent.fullscreen;
    }

    @:noCompletion private function set_fullscreen(value:Bool):Bool {
        return parent.fullscreen = value;
    }

    @:noCompletion private function set_parent(window:Window):Window {
        if(applyWindowSurface) {
            __renderer.applyWindowSurface(SpoopyEngine.device);
        }

        return parent = window;
    }
}