package spoopy.graphics.commands;

import spoopy.utils.SpoopyDestroyable;
import spoopy.graphics.SpoopyWindowContext;
import spoopy.utils.SpoopyLogger;

@:allow(spoopy.graphics.SpoopyWindowContext)
class SpoopyCommandManager implements ISpoopyDestroyable {
    public var pool(get, never):SpoopyCommandPool;

    @:noCompletion private var __pool:SpoopyCommandPool;

    public function new() {
        __pool = new SpoopyCommandPool(this);
    }

    public function destroy():Void {
        __pool.destroy();
        __pool = null;
    }

    @:noCompletion private function get_pool():SpoopyCommandPool {
        return __pool;
    }
}