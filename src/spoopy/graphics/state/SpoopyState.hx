package spoopy.graphics.state;

import spoopy.utils.destroy.SpoopyDestroyable;
import spoopy.utils.SpoopyLogger;
import spoopy.graphics.renderer.SpoopyRenderPass;
import spoopy.graphics.commands.SpoopyCommandBuffer;
import spoopy.graphics.commands.SpoopyCommandManager;
import spoopy.graphics.SpoopyGraphicsModule;

@:allow(spoopy.graphics.state.SpoopyStateManager)
class SpoopyState implements ISpoopyDestroyable {
    public var manager(get, never):SpoopyStateManager;

    @:noCompletion private var __renderPass:SpoopyRenderPass;
    @:noCompletion private var __activeCmdBuffer:SpoopyCommandBuffer<SpoopyGraphicsModule>;
    @:noCompletion private var __manager:SpoopyStateManager;
    @:noCompletion private var __isBound:Bool;

    public function new(renderpass:SpoopyRenderPass = null) {

        // It's up to the game dev to optimize the renderpass for the state.

        if(__renderPass != null) {
            __renderPass = renderpass;
            __isBound = false;
        }else {
            __renderPass = new SpoopyRenderPass(manager.module);
            __isBound = true;
        }
    }

    /*
    * This is called when the state successfully created with everything intact.
    */
    public function create():Void {}

    public function destroy():Void {
        flush();

        __activeCmdBuffer = null;
        __manager = null;
    }

    @:noCompletion private function get_manager():SpoopyStateManager {
        if(__manager == null) {
            SpoopyLogger.error("State is not bound to a manager!");
        }

        return __manager;
    }

    @:noCompletion private inline function bind(manager:SpoopyStateManager, cmdManager:SpoopyCommandManager<SpoopyGraphicsModule>):Void {
        __manager = manager;
        __activeCmdBuffer = cmdManager.getCmdBuffer();
    }

    private function flush():Void {
        /* TODO: Flush out Vulkan buffers and the descriptor pool that is attached to the current state. */

        if(__isBound) {
            __renderPass.destroy();
            __renderPass = null;
        }
    }
}