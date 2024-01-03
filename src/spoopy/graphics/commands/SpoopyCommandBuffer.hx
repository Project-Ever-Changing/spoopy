package spoopy.graphics.commands;

import spoopy.window.IWindowHolder;
import spoopy.backend.native.SpoopyNativeCFFI;
import spoopy.utils.destroy.SpoopyDestroyable;
import spoopy.graphics.modules.SpoopyGPUObject;

@:allow(spoopy.graphics.commands.SpoopyCommandPool)
class SpoopyCommandBuffer<T:IWindowHolder> implements ISpoopyDestroyable {
    public var parent(get, never):SpoopyCommandPool<T>;
    public var state(get, never):SpoopyCommandState;

    @:noCompletion private var __holder:T;
    @:noCompletion private var __parent:SpoopyCommandPool<T>;
    @:noCompletion private var __handle:SpoopyCommandBufferBackend;
    @:noCompletion private var __state:SpoopyCommandState;
    @:noCompletion private var __fence:SpoopyFence;
    @:noCompletion private var __waitSemaphores:Array<SpoopyGPUObject>;
    @:noCompletion private var __signalSemaphores:Array<SpoopyGPUObject>;

    private function new(parent:SpoopyCommandPool<T>, begin:Bool = true) {
        __state = WAITING_FOR_BEGIN;
        __parent = parent;
        __holder = parent.parent.holder;

        if(begin && __state != WAITING_FOR_BEGIN) {
            throw "Command buffer is not in a state to begin.";
        }

        // TODO: If OpenGL, then have an actual constructor.
        __handle = SpoopyStaticBackend.spoopy_create_command_buffer(parent.__handle, begin);
        __state = begin ? HAS_BEGUN : __state;

        __waitSemaphores = [];
        __signalSemaphores = [];

        __fence = SpoopyBackendEngine.fenceManager.alloc();
    }

    public function submit():Void {

    }

    public function destroy():Void {
        if(__state == SUBMITTED) {
            SpoopyBackendEngine.fenceManager.waitAndReleaseFence(__fence, 3.3e+10); // 33ms
        }else {
            SpoopyBackendEngine.fenceManager.releaseFence(__fence);
        }

        __handle = null;
        __parent = null;
        __holder = null;
    }

    @:noCompletion private function get_parent():SpoopyCommandPool<T> {
        return __parent;
    }

    @:noCompletion private function get_state():SpoopyCommandState {
        return __state;
    }
}

// TODO: If OpenGL, then have an actual handle class.
typedef SpoopyFence = spoopy.backend.native.SpoopyNativeFence;
typedef SpoopyStaticBackend = spoopy.backend.native.SpoopyNativeCFFI;
typedef SpoopyBackendEngine = spoopy.backend.native.SpoopyNativeEngine;
typedef SpoopyCommandBufferBackend = Dynamic;