package spoopy.display;

import lime.ui.Window;

/*
 * Handles anything having to do window related so the game doesn't have too.
 */
class WindowStage {
    var parent:Window;

    public var width(get, set):Int;
    public var height(get, set):Int;

    public var frameRate(get, set):Int;
    public var fullscreen(get, set):Bool;

    public function new(parent:Window) {
        this.parent = parent;
        super();
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

    @:noCompletion private inline function get_frameRate():Int {
        return parent.frameRate;
    }

    @:noCompletion private function set_frameRate(value:Int):Int {
        return parent.frameRate = value;
    }

    @:noCompletion private inline function get_fullscreen():Bool {
        return parent.fullscreen;
    }

    @:noCompletion private function set_fullscreen(value:Bool):Bool {
        return parent.fullscreen = value;
    }
}