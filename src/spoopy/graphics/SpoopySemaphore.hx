package spoopy.graphics;

import spoopy.utils.destroy.SpoopyDestroyable;
import spoopy.graphics.SpoopyGraphicsModule;
import spoopy.backend.native.SpoopyNativeCFFI;

/*
* CAREFUL: Do not de-allocate the semaphore regularaly!
* YOU MUST: Use the `destroy()` method to de-allocate the semaphore safely then `semaphore = null.`
*/

class SpoopySemaphore implements ISpoopyDestroyable implements  {
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