package spoopy.backend.native;

import spoopy.utils.SpoopyLogger;

class SpoopyNativeFenceManager {
    @:noCompletion private var __freeFences:Array<SpoopyNativeFence>;
    @:noCompletion private var __inUseFences:Array<SpoopyNativeFence>;

    public function new() {
        __freeFences = [];
        __inUseFences = [];
    }

    public function alloc(signaled:Bool = false):SpoopyNativeFence {
        SpoopyNativeCFFI.spoopy_device_lock_fence();
        var fence:SpoopyNativeFence = null;

        if(__freeFences.length > 0) {
            fence = __freeFences.pop();
            __inUseFences.push(fence);

            if(signaled) fence.setSignal(true);
            SpoopyNativeCFFI.spoopy_device_unlock_fence();
            return fence;
        }

        fence = new SpoopyNativeFence(signaled);
        __inUseFences.push(fence);
        SpoopyNativeCFFI.spoopy_device_unlock_fence();
        return fence;
    }

    public function dispose():Void {
        SpoopyNativeCFFI.spoopy_device_lock_fence();

        while(__freeFences.length > 0) {
            var fence = __freeFences.shift();
            fence.destroy();
            fence = null;
        }

        SpoopyNativeCFFI.spoopy_device_unlock_fence();
    }

    public function moveFence(createSignaled:Bool):SpoopyNativeFence {
        SpoopyNativeCFFI.spoopy_device_lock_fence();

        var fence:SpoopyNativeFence;

        if(__freeFences.length > 0) {
            fence = __freeFences.pop();
            __inUseFences.push(fence);

            if(createSignaled) fence.setSignal(true);
            SpoopyNativeCFFI.spoopy_device_unlock_fence();
            return fence;
        }

        fence = new SpoopyNativeFence(createSignaled);
        __inUseFences.push(fence);
        SpoopyNativeCFFI.spoopy_device_unlock_fence();
        return fence;
    }

    public function waitForFence(fence:SpoopyNativeFence, nanoseconds:Int):Bool {
        if(__inUseFences.indexOf(fence) == -1) {
            SpoopyLogger.error("SpoopyNativeFenceManager.waitForFence: Fence is not in use!");
            return false;
        }

        return fence.wait(nanoseconds);
    }

    public function releaseFence(fence:SpoopyNativeFence):Void {
        SpoopyNativeCFFI.spoopy_device_lock_fence();

        fence.reset();
        __inUseFences.remove(fence);
        __freeFences.push(fence);
        fence = null;

        SpoopyNativeCFFI.spoopy_device_unlock_fence();
    }

    public function waitAndReleaseFence(fence:SpoopyNativeFence, nanoseconds:Int):Void {
        SpoopyNativeCFFI.spoopy_device_lock_fence();
        if(!fence.signaled) fence.wait(nanoseconds);

        fence.reset();
        __inUseFences.remove(fence);
        __freeFences.push(fence);
        fence = null;

        SpoopyNativeCFFI.spoopy_device_unlock_fence();
    }
}