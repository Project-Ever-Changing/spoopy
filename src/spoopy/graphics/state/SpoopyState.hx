package spoopy.graphics.state;

import spoopy.utils.SpoopyDestroyable;
import spoopy.utils.SpoopyLogger;
import spoopy.graphics.renderer.SpoopyRenderPass;
import spoopy.graphics.commands.SpoopyCommandBuffer;
import spoopy.graphics.SpoopyWindowContext;

@:allow(spoopy.graphics.state.SpoopyStateManager)
class SpoopyState implements ISpoopyDestroyable {
    public var manager(get, never):SpoopyStateManager;

    @:noCompletion private var __renderPass:SpoopyRenderPass;
    @:noCompletion private var __activeCmdBuffer:SpoopyCommandBuffer<SpoopyWindowContext>;
    @:noCompletion private var __manager:SpoopyStateManager;

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
        __manager = null;
    }

    @:noCompletion private function get_manager():SpoopyStateManager {
        if(__manager == null) {
            SpoopyLogger.error("State is not bound to a manager!");
        }

        return __manager;
    }

    @:noCompletion private inline function bind(manager:SpoopyStateManager):Void {
        __manager = manager;
    }

    private function flush():Void {
        /* TODO: Flush out Vulkan buffers and the descriptor pool that is attached to the current state. */
    }
}