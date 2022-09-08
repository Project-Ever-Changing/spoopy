package spoopy.display;

import lime.ui.Window;
import spoopy.events.EventHandler;
import spoopy.events.EventListener;
import spoopy.system.SpoopyUtils;

/*
 * Window events pretty much.
 */
 @:enum abstract WindowEvents(String) to String from String {
    var ON_WINDOW_ACTIVE = "active";
    var ON_WINDOW_DEACTIVE = "deactive";
    var ON_WINDOW_CLOSE = "close";
    var ON_WINDOW_RESIZE = "resize";
    var ON_WINDOW_FOCUS_IN = "focusIn";
    var ON_WINDOW_FOCUS_OUT = "focusOut";
    var ON_WINDOW_RENDER = "enterFrame";
    var ON_WINDOW_DROP_FILE = "dropFile";
    var ON_WINDOW_EXPOSE = "expose";
    var ON_WINDOW_FULLSCREEN = "fullscreen";
    var ON_WINDOW_KEY_DOWN = "keyDown";
    var ON_WINDOW_KEY_UP = "keyUp";
    var ON_WINDOW_LEAVE = "leave";
    var ON_WINDOW_MINIMIZE = "minimize";
    var ON_WINDOW_MOUSE_DOWN = "mouseDown";
    var ON_WINDOW_MOUSE_UP = "mouseUp";
    var ON_WINDOW_MOUSE_WHEEL = "mouseWheel";
    var ON_WINDOW_MOVE = "move";
    var ON_WINDOW_RENDER_CONTEXT_LOST = "renderContextLost";
    var ON_WINDOW_RENDER_CONTEXT_RESTORED = "renderContextRestored";
    var ON_WINDOW_RESTORE = "restore";
    var ON_WINDOW_TEXT_EDIT = "textEdit";
    var ON_WINDOW_TEXT_INPUT = "textInput";
}

/*
 * Handles anything having to do window related so the game doesn't have too.
 */
class WindowStage extends EventHandler {
    public var parent(default, null):Window;

    public var width(get, set):Int;
    public var height(get, set):Int;

    public function new(parent:Window) {
        this.parent = parent;
        super();
    }

    override public function addEventListener(type:String, listener:Void->Void) {
        var windowEventList:Array<String> = SpoopyUtils.getEnumValues(WindowEvents);

        if(!windowEventList.contains(type)) {
            return;
        }

        super.addEventListener(type, listener);
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
}