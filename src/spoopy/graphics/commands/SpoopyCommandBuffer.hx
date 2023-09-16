package spoopy.graphics.commands;

import spoopy.backend.native.SpoopyNativeCFFI;

class SpoopyCommandBuffer {
    public var parent(get, never):SpoopyCommandPool;

    @:noCompletion private var __parent:SpoopyCommandPool;
    @:noCompletion private var __handle:SpoopyCommandBufferBackend;

    public function new(parent:SpoopyCommandPool) {
        __parent = parent;

        // TODO: If OpenGL, then have an actual constructor.
        handle = SpoopyNativeCFFI.spoopy_create_command_buffer(parent.handle);
    }

    @:noCompletion private function get_parent():SpoopyCommandPool {
        return __parent;
    }
}

//TODO: If OpenGL, then have an actual handle class.
typedef SpoopyCommandBufferBackend = Dynamic;