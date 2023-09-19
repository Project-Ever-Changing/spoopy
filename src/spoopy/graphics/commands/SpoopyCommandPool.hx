package spoopy.graphics.commands;

import spoopy.utils.SpoopyLogger;
import spoopy.utils.SpoopyDestroyable;
import spoopy.graphics.SpoopyWindowContext;
import spoopy.backend.native.SpoopyNativeCFFI;

@:access(lime.ui.Window)
@:allow(spoopy.graphics.commands.SpoopyCommandBuffer)
@:allow(spoopy.graphics.commands.SpoopyCommandManager)
class SpoopyCommandPool<T:SpoopyWindowContext> implements ISpoopyDestroyable {
    public var manager(get, never):SpoopyCommandManager<T>;

    @:noCompletion private var __handle:SpoopyCommandPoolBackend;
    @:noCompletion private var __manager:SpoopyCommandManager<T>;
    @:noCompletion private var __cmdBuffers:Array<SpoopyCommandBuffer<T>>;

    public function new(manager:SpoopyCommandManager<T>) {
        __cmdBuffers = [];

        // TODO: If OpenGL, then have an actual constructor.
        __handle = SpoopyNativeCFFI.spoopy_create_command_pool(manager.parent.window.__backend.handle);
    }

    public function createBuffer():SpoopyCommandBuffer<T> {
        var cmdBuffer = new SpoopyCommandBuffer(this, true);
        __cmdBuffers.push(cmdBuffer);

        #if spoopy_debug
        SpoopyLogger.success("Successfully created command buffer and binded it to the pool.");
        #end

        return cmdBuffer;
    }

    public function destroyBuffer(cmdBuffer:SpoopyCommandBuffer<T>):Void {
        cmdBuffer.destroy();
        __cmdBuffers.remove(cmdBuffer);
        cmdBuffer = null;
    }

    public function destroy():Void {
        while(__cmdBuffers[0] != null) {
            __cmdBuffers[0].destroy();
            __cmdBuffers.pop();
        }

        __handle = null;
        __cmdBuffers = null;
        __manager = null;
    }

    @:noCompletion private function get_manager():SpoopyCommandManager<T> {
        return __manager;
    }
}

//TODO: If OpenGL, then have an actual handle class.
typedef SpoopyCommandPoolBackend = Dynamic;