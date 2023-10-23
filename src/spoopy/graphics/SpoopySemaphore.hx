package spoopy.graphics;

import spoopy.utils.destroy.SpoopyDestroyable;
import spoopy.graphics.SpoopyGraphicsModule;
import spoopy.backend.native.SpoopyNativeCFFI;

class SpoopySemaphore implements ISpoopyDestroyable {
    @:noCompletion private var __handle:SpoopySemaphoreBackend;
    @:noCompletion private var __module:SpoopyGraphicsModule;

    public function new(module:SpoopyGraphicsModule) {
        __module = module;

        // TODO: If OpenGL, then have an actual constructor.
        __handle = SpoopyNativeCFFI.spoopy_create_semaphore();
    }

    public function destroy():Void {

    }

    private inline function flush():Void {
        
    }
}

// TODO: If OpenGL, then have an actual handle class.
typedef SpoopySemaphoreBackend = Dynamic;