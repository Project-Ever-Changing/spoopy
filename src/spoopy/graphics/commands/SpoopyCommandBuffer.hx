package spoopy.graphics.commands;

import spoopy.window.IWindowHolder;
import spoopy.backend.SpoopyStaticBackend;
import spoopy.backend.native.SpoopyNativeCFFI;
import spoopy.utils.destroy.SpoopyDestroyable;
import spoopy.utils.SpoopyLogger;
import spoopy.graphics.modules.SpoopyGPUObject;
import spoopy.graphics.descriptor.SpoopyDescriptorPoolContainer;
import spoopy.app.SpoopyEngine;

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
    @:noCompletion private var __submittedSemaphores:Array<SpoopyGPUObject>;
    @:noCompletion private var __descriptorPoolContainer:SpoopyDescriptorPoolContainer;
    @:noCompletion private var __fenceSignaledCounter:Int;
    @:noCompletion private var __submittedFenceSignaledCounter:Int;

    private function new(parent:SpoopyCommandPool<T>, begin:Bool = true) {
        __state = WAITING_FOR_BEGIN;
        __parent = parent;
        __holder = parent.manager.parent;

        __handle = SpoopyStaticBackend.spoopy_create_command_buffer(parent.__handle, begin);
        __state = begin ? HAS_BEGUN : __state;

        __waitSemaphores = [];
        __submittedSemaphores = [];

        __fence = SpoopyBackendEngine.fenceManager.alloc();
        __fenceSignaledCounter = 0;
        __submittedFenceSignaledCounter = 0;

        __descriptorPoolContainer = SpoopyEngine.INSTANCE.descriptorManager.acquirePoolContainer();
    }

    public function begin():Void {
        SpoopyStaticBackend.spoopy_command_buffer_begin_record(__handle);
    }

    public function destroy():Void {
        if(__state == SUBMITTED) {
            var milliseconds:haxe.Int64 = (1000 / SpoopyEngine.INSTANCE.drawFramerate) * 1e+9;
            SpoopyBackendEngine.fenceManager.waitAndReleaseFence(__fence, milliseconds);
        }else {
            SpoopyBackendEngine.fenceManager.releaseFence(__fence);
        }

        if(__state != DESTROYED) {
            SpoopyStaticBackend.spoopy_command_buffer_free(__handle);
        }

        __handle = null;
        __parent = null;
        __holder = null;

        __state = DESTROYED;
    }

    public function submit(signalSemaphore:SpoopyGPUObject):Void {
        __state = SpoopyStaticBackend.spoopy_queue_submit(
            __handle,
            __fence,
            __waitSemaphores,
            __state,
            signalSemaphore
        );

        for(i in 0...__submittedSemaphores.length) { // GC the old semaphores.
            var submittedSemaphore:SpoopyGPUObject = __submittedSemaphores[i];
            submittedSemaphore.destroy();
        }

        __submittedSemaphores = __waitSemaphores;
        __waitSemaphores = [];
        __submittedFenceSignaledCounter = __fenceSignaledCounter;
    }

    public function refreshFenceStatus():Void {
        if(__state != SUBMITTED) {
            SpoopyLogger.error("This command buffer has not been submitted!");
            return;
        }

        if(__fence.signaled) {
            __state = WAITING_FOR_BEGIN;

            // Destroy all submitted semaphores before clearing the array.
            for(i in 0...__submittedSemaphores.length) {
                var submittedSemaphore:SpoopyGPUObject = __submittedSemaphores[i];
                submittedSemaphore.destroy();
            }

            __submittedSemaphores = [];
            SpoopyStaticBackend.spoopy_command_buffer_reset(__handle);
            __fenceSignaledCounter++;

            if(__descriptorPoolContainer != null) {
                SpoopyEngine.INSTANCE.descriptorManager.releasePoolContainer(__descriptorPoolContainer);
                __descriptorPoolContainer = null;
            }
        }else {
            SpoopyLogger.error("This command buffer has not been signaled!");
        }
    }

    public inline function hasBegun():Bool {
        return __state == HAS_BEGUN || __state == INSIDE_RENDER_PASS;
    }

    public inline function endRenderPass():Void {
        SpoopyStaticBackend.spoopy_command_buffer_end_render_pass(__handle);
        __state = HAS_BEGUN;
    }

    public inline function end():Void {
        if(__state != HAS_BEGUN) {
            SpoopyLogger.error("This command buffer has not been begun!");
            return;
        }

        SpoopyStaticBackend.spoopy_command_buffer_end_record(__handle);
        __state = HAS_ENDED;
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
typedef SpoopyBackendEngine = spoopy.backend.native.SpoopyNativeEngine;
typedef SpoopyCommandBufferBackend = Dynamic;