package spoopy.backend.native;

import spoopy.utils.destroy.SpoopyDestroyable;

class SpoopyNativeSemaphore implements ISpoopyDestroyable {
    public var handle:Dynamic;

    public function new() {
        handle = SpoopyNativeCFFI.spoopy_create_threading_semaphore();
    }

    public function wait():Void {
        SpoopyNativeCFFI.spoopy_threading_semaphore_wait(handle);
    }

    public function set():Void {
        SpoopyNativeCFFI.spoopy_threading_semaphore_set(handle);
    }

    public function destroy():Void {
        SpoopyNativeCFFI.spoopy_threading_semaphore_destroy(handle);
    }
}