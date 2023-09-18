package spoopy.graphics.commands;

import spoopy.backend.native.SpoopyNativeCFFI;
import spoopy.utils.SpoopyLogger;

@:access(lime.ui.Window)
@:allow(spoopy.graphics.commands.SpoopyCommandBuffer)
@:allow(spoopy.graphics.commands.SpoopyCommandManager)
class SpoopyCommandPool {
    public var manager(get, never):SpoopyCommandManager;

    @:noCompletion private var __handle:SpoopyCommandPoolBackend;
    @:noCompletion private var __manager:SpoopyCommandManager;
    @:noCompletion private var __cmdBuffers:Array<SpoopyCommandBuffer>;

    public function new(manager:SpoopyCommandManager) {
        __cmdBuffers = [];

        // TODO: If OpenGL, then have an actual constructor.
        __handle = SpoopyNativeCFFI.spoopy_create_command_pool(manager.context.window.__backend.handle);
    }

    public function createBuffer():SpoopyCommandBuffer {
        var cmdBuffer = new SpoopyCommandBuffer(this, true);
        __cmdBuffers.push(cmdBuffer);

        #if spoopy_debug
        SpoopyLogger.success("Successfully created command buffer and binded it to the pool.");
        #end

        return cmdBuffer;
    }

    @:noCompletion private function get_manager():SpoopyCommandManager {
        return __manager;
    }
}

//TODO: If OpenGL, then have an actual handle class.
typedef SpoopyCommandPoolBackend = Dynamic;