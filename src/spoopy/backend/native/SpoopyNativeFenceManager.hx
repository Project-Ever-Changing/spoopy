package spoopy.backend.native;

import spoopy.utils.SpoopyLogger;
import spoopy.app.SpoopyApplication;

import haxe.io.Bytes;

class SpoopyNativeFenceManager {
    @:noCompletion private var __freeFences:Array<SpoopyNativeFence>;
    @:noCompletion private var __inUseFences:Array<SpoopyNativeFence>;
    @:noCompletion private var __cachedNanoSeconds:haxe.Int64;
    @:noCompletion private var __cachedNanoBytes:Bytes;

    public function new() {
        __freeFences = [];
        __inUseFences = [];

        __cachedNanoSeconds = 0;
        __cachedNanoBytes = null;
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

    public function waitForFence(fence:SpoopyNativeFence, nanoseconds:haxe.Int64):Bool {
        if(__inUseFences.indexOf(fence) == -1) {
            SpoopyLogger.error("SpoopyNativeFenceManager.waitForFence: Fence is not in use!");
            return false;
        }

        __cacheNanoBytes(nanoseconds);
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

    public function waitAndReleaseFence(fence:SpoopyNativeFence, nanoseconds:Int):Void {
        SpoopyNativeCFFI.spoopy_device_lock_fence();
        if(!fence.signaled) {
            __cacheNanoBytes(nanoseconds);
            fence.wait(__cachedNanoBytes);
        }

        fence.reset();
        __inUseFences.remove(fence);
        __freeFences.push(fence);
        fence = null;

        SpoopyNativeCFFI.spoopy_device_unlock_fence();
    }

    @:noCompletion private function __cacheNanoBytes(nanoseconds:haxe.Int64):Void {
        if(__cachedNanoSeconds != nanoseconds) {
            __cachedNanoBytes = SpoopyApplication.malloc64(__cachedNanoSeconds);
            __cachedNanoSeconds = nanoseconds;
        }
    }
}