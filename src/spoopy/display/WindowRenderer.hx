package spoopy.display;

import lime.ui.Window;

class WindowRenderer {
    public var parent(default, null):Window;

    public function new(parent:Window) {
        this.parent = parent;
    }
}