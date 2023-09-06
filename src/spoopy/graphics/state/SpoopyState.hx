package spoopy.graphics.state;

import spoopy.utils.SpoopyDestroyable;

@:allow(spoopy.graphics.state.SpoopyStateManager)
class SpoopyState implements ISpoopyDestroyable {
    public var manager(default, null):SpoopyStateManager;

    public function new() {

    }

    /*
    * This is callec when the state successfully created with everything intact.
    */
    public function create():Void {}

    public function destroy():Void {
        flush();

        manager = null;
    }

    private function flush():Void {
        /* TODO: Flush out Vulkan buffers and the descriptor pool that is attached to the current state. */
    }

    private inline function addManager(manager:SpoopyStateManager):Void {
        this.manager = manager;
    }
}