package spoopy.graphics.commands;

import spoopy.utils.SpoopyLogger;
import spoopy.utils.destroy.SpoopyDestroyable;
import spoopy.graphics.modules.SpoopyGPUObject;
import spoopy.window.IWindowHolder;

/*
* I want to keep the command manager as a separate class from the command pool.
* Since the command pool acts more as a frontend wrapper for the vulkan command pool's handle.
*/

class SpoopyCommandManager<T:IWindowHolder> implements ISpoopyDestroyable {
    public var parent(get, never):T;
    public var pool(get, never):SpoopyCommandPool<T>;

    @:noCompletion private var __pool:SpoopyCommandPool<T>;
    @:noCompletion private var __activeCmdBuffer:SpoopyCommandBuffer<T>;
    @:noCompletion private var __parent:T;

    public function new(parent:T) {
        __parent = parent;
        __pool = new SpoopyCommandPool<T>(this);
    }

    public function submitActiveCmdBuffer(signalSemaphore:SpoopyGPUObject):Void {
        if(__activeCmdBuffer.hasBegun()) {
            if(__activeCmdBuffer.state == INSIDE_RENDER_PASS) {
                __activeCmdBuffer.endRenderPass();
            }
        }

        __activeCmdBuffer.end();
        __activeCmdBuffer.submit(signalSemaphore);
        __activeCmdBuffer = null;
    }

    public function prepareNewActiveCmdBuffer():Void {
        for(i in 0...__pool.__cmdBuffers.length) {
            var cmdBuffer = __pool.__cmdBuffers[i];
            cmdBuffer.refreshFenceStatus();

            if(cmdBuffer.state == WAITING_FOR_BEGIN) {
                __activeCmdBuffer = cmdBuffer;
                __activeCmdBuffer.begin();
                return;
            }else if(cmdBuffer.state != SUBMITTED) {
                SpoopyLogger.error("Command buffer is in an invalid state for reuse.");
                return;
            }
        }

        __activeCmdBuffer = __pool.createCmdBuffer();
    }

    public function getCmdBuffer():SpoopyCommandBuffer<T> {
        if(__activeCmdBuffer == null) {
            prepareNewActiveCmdBuffer();
        }

        return __activeCmdBuffer;
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