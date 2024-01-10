package spoopy.backend.native;

import spoopy.io.SpoopyU64;
import spoopy.utils.SpoopyLogger;
import spoopy.app.SpoopyApplication;

class SpoopyNativeFenceManager {
    @:noCompletion private var __freeFences:Array<SpoopyNativeFence>;
    @:noCompletion private var __inUseFences:Array<SpoopyNativeFence>;

    #if (!cpp || cppia)
    @:noCompletion private var __cachedNanoSeconds:SpoopyU64;
    @:noCompletion private var __cachedNanoBytes:haxe.io.Bytes;
    #end

    public function new() {
        __freeFences = [];
        __inUseFences = [];

        #if (!cpp || cppia)
        __cachedNanoSeconds = 0;
        __cachedNanoBytes = null;
        #end
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

    public function waitForFence(fence:SpoopyNativeFence, nanoseconds:SpoopyU64):Bool {
        if(__inUseFences.indexOf(fence) == -1) {
            SpoopyLogger.error("SpoopyNativeFenceManager.waitForFence: Fence is not in use!");
            return false;
        }

        #if (!cpp || cppia)
        __cacheNanoBytes(nanoseconds);
        #end

        return fence.wait(__cachedNanoBytes);
    }

    public function releaseFence(fence:SpoopyNativeFence):Void {
        SpoopyNativeCFFI.spoopy_device_lock_fence();

        fence.reset();
        __inUseFences.remove(fence);
        __freeFences.push(fence);
        fence = null;

        SpoopyNativeCFFI.spoopy_device_unlock_fence();
    }

    public function waitAndReleaseFence(fence:SpoopyNativeFence, nanoseconds:SpoopyU64):Void {
        SpoopyNativeCFFI.spoopy_device_lock_fence();
        if(!fence.signaled) {
            #if (!cpp || cppia)
            __cacheNanoBytes(nanoseconds);
            fence.wait(__cachedNanoBytes);
            #else
            fence.wait(nanoseconds);
            #end
        }

        fence.reset();
        __inUseFences.remove(fence);
        __freeFences.push(fence);
        fence = null;

        SpoopyNativeCFFI.spoopy_device_unlock_fence();
    }

    #if (!cpp || cppia)
    @:noCompletion private function __cacheNanoBytes(nanoseconds:SpoopyU64):Void {
        if(__cachedNanoSeconds == nanoseconds) {
            return;
        }

        __cachedNanoBytes = SpoopyApplication.malloc8(__cachedNanoSeconds);
        __cachedNanoSeconds = nanoseconds;
    }
    #end
}