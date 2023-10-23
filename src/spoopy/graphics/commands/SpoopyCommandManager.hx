package spoopy.graphics.commands;

import spoopy.utils.SpoopyLogger;
import spoopy.utils.SpoopyDestroyable;
import spoopy.window.IWindowHolder;

/*
* I want to keep the command manager as a separate class from the command pool.
* Since the command pool acts more as a frontend wrapper for the vulkan command pool's handle.
*/

class SpoopyCommandManager<T:IWindowHolder> implements ISpoopyDestroyable {
    public var parent(get, never):T;
    public var pool(get, never):SpoopyCommandPool<T>;

    @:noCompletion private var __pool:SpoopyCommandPool<T>;
    @:noCompletion private var __parent:T;

    public function new(parent:T) {
        __parent = parent;
        __pool = new SpoopyCommandPool<T>(this);
    }

    /*
    public function createCmdBuffer(oldCmdBuffer:SpoopyCommandBuffer<T>):SpoopyCommandBuffer<T> {
        switch(oldCmdBuffer) {
            case null:

        }
    }
    */

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