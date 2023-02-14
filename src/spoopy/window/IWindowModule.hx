package spoopy.window;

import lime.ui.Window;

interface IWindowModule {
    @:noCompletion private function __registerWindowModule(window:Window):Void;
    @:noCompletion private function __unregisterWindowModule(window:Window):Void;
}