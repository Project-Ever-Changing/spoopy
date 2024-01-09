package spoopy.backend.native;

import spoopy.graphics.modules.SpoopyFlags;
import spoopy.utils.destroy.SpoopyDestroyable.ISpoopyDestroyable;

class SpoopyNativeFence implements ISpoopyDestroyable {
    public var signaled(default, null):Bool;
    public var handle:Dynamic;

    public function new(signaled:Bool) {
        this.signaled = signaled;
        handle = SpoopyNativeCFFI.spoopy_create_gpu_fence(signaled);
    }

    public function wait(nanoseconds:haxe.Int64):Bool {
        return SpoopyNativeCFFI.spoopy_wait_gpu_fence(handle, nanoseconds);
    }

    public function setSignal(signaled:Bool):Void {
        this.signaled = signaled;
        SpoopyNativeCFFI.spoopy_set_gpu_fence_signal(handle, this.signaled);
    }

    public function reset():Void {
        SpoopyNativeCFFI.spoopy_reset_gpu_fence(handle);
    }

    public function destroy():Void {
        SpoopyNativeCFFI.spoopy_dealloc_gpu_cffi_pointer(SpoopyFlags.FENCE, handle);
    }
}