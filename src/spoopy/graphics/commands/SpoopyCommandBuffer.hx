package spoopy.graphics.commands;

import spoopy.window.IWindowHolder;
import spoopy.backend.native.SpoopyNativeCFFI;
import spoopy.utils.SpoopyDestroyable;

@:allow(spoopy.graphics.commands.SpoopyCommandPool)
class SpoopyCommandBuffer<T:IWindowHolder> implements ISpoopyDestroyable {
    public var parent(get, never):SpoopyCommandPool<T>;
    public var state(get, never):SpoopyCommandState;

    @:noCompletion private var __parent:SpoopyCommandPool<T>;
    @:noCompletion private var __handle:SpoopyCommandBufferBackend;
    @:noCompletion private var __state:SpoopyCommandState;

    private function new(parent:SpoopyCommandPool<T>, begin:Bool = true) {
        __state = WAITING_FOR_BEGIN;
        __parent = parent;

        if(begin && __state != WAITING_FOR_BEGIN) {
            throw "Command buffer is not in a state to begin.";
        }

        // TODO: If OpenGL, then have an actual constructor.
        __handle = SpoopyNativeCFFI.spoopy_create_command_buffer(parent.__handle, begin);
        __state = begin ? HAS_BEGUN : __state;
    }

    public function destroy():Void {
        __handle = null;
        __parent = null;
    }

    @:noCompletion private function get_parent():SpoopyCommandPool<T> {
        return __parent;
    }

    @:noCompletion private function get_state():SpoopyCommandState {
        return __state;
    }
}

// TODO: If OpenGL, then have an actual handle class.
typedef SpoopyCommandBufferBackend = Dynamic;