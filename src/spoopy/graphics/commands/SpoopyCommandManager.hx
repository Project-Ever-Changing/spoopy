package spoopy.graphics.commands;

import spoopy.utils.SpoopyLogger;
import spoopy.utils.SpoopyDestroyable;
import spoopy.window.IWindowHolder;

class SpoopyCommandManager<T:IWindowHolder> implements ISpoopyDestroyable {
    public var parent(get, never):T;
    public var pool(get, never):SpoopyCommandPool<T>;

    @:noCompletion private var __pool:SpoopyCommandPool<T>;
    @:noCompletion private var __parent:T;

    public function new(parent:T) {
        __pool = new SpoopyCommandPool<T>(this);
        __parent = parent;
    }

    public function destroy():Void {
        __pool.destroy();
        __pool = null;
    }

    @:noCompletion private function get_pool():SpoopyCommandPool<T> {
        return __pool;
    }

    @:noCompletion private function get_parent():T {
        return __parent;
    }
}