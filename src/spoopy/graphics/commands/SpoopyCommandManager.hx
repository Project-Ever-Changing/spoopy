package spoopy.graphics.commands;

import spoopy.graphics.SpoopyWindowContext;
import spoopy.utils.SpoopyLogger;

@:allow(spoopy.graphics.SpoopyWindowContext)
class SpoopyCommandManager {
    public var pool(get, never):SpoopyCommandPool;
    public var context(get, never):SpoopyWindowContext;

    @:noCompletion private var __context:SpoopyWindowContext;
    @:noCompletion private var __pool:SpoopyCommandPool;

    public function new(context:SpoopyWindowContext) {
        __context = context;
        __pool = new SpoopyCommandPool(this);
    }

    @:noCompletion private function get_context():SpoopyWindowContext {
        if(__context == null) {
            SpoopyLogger.error("SpoopyCommandManager is required to have a context!");
        }

        return __context;
    }

    @:noCompletion private function get_pool():SpoopyCommandPool {
        return __pool;
    }
}