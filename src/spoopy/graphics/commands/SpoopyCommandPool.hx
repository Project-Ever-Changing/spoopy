package spoopy.graphics.commands;

import spoopy.backend.native.SpoopyNativeCFFI;

@:access(lime.ui.Window)
@:allow(spoopy.graphics.commands.SpoopyCommandBuffer)
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

    @:noCompletion private function get_manager():SpoopyCommandManager {
        return __manager;
    }
}

//TODO: If OpenGL, then have an actual handle class.
typedef SpoopyCommandPoolBackend = Dynamic;