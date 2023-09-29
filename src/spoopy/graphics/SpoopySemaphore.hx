package spoopy.graphics;

import spoopy.backend.native.SpoopyNativeCFFI;

class SpoopySemaphore {
    @:noCompletion private var __handle:SpoopySemaphoreBackend;

    public function new() {

        // TODO: If OpenGL, then have an actual constructor.
        __handle = SpoopyNativeCFFI.spoopy_create_semaphore();
    }
}

// TODO: If OpenGL, then have an actual handle class.
typedef SpoopySemaphoreBackend = Dynamic;