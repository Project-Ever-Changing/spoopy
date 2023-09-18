package spoopy.graphics.state;

import spoopy.utils.SpoopyDestroyable;
import spoopy.graphics.renderer.SpoopyRenderPass;

@:allow(spoopy.graphics.state.SpoopyStateManager)
class SpoopyState implements ISpoopyDestroyable {
    public var manager(default, null):SpoopyStateManager;

    @:noCompletion private var __renderPass:SpoopyRenderPass;
    @:noCompletion private var __activeCmdBuffer:SpoopyCommandBuffer;

    public function new() {

    }

    /*
    * This is callec when the state successfully created with everything intact.
    */
    public function create():Void {}

    public function destroy():Void {
        flush();

        __renderPass = null;
        __activeCmdBuffer = null;
        manager = null;
    }

    @:noCompletion private inline function bind(manager:SpoopyStateManager):Void {
        __manager = manager;

        
    }

    private function flush():Void {
        /* TODO: Flush out Vulkan buffers and the descriptor pool that is attached to the current state. */
    }

    private inline function addManager(manager:SpoopyStateManager):Void {
        this.manager = manager;
    }
}