package spoopy.window;

import lime.ui.Window;

interface IWindowHolder {
    public var window(get, never):Window;

    @:noCompletion private function get_window():Window;
}