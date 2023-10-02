package spoopy.graphics;

import spoopy.utils.SpoopyDestroyable;
import spoopy.backend.native.SpoopyNativeCFFI;

class SpoopySemaphore implements ISpoopyDestroyable {
    @:noCompletion private var __handle:SpoopySemaphoreBackend;

    public function new() {

        // TODO: If OpenGL, then have an actual constructor.
        __handle = SpoopyNativeCFFI.spoopy_create_semaphore();
    }

    public function destroy():Void {
        
    }
}

// TODO: If OpenGL, then have an actual handle class.
typedef SpoopySemaphoreBackend = Dynamic;