package spoopy.graphics.modules;

import spoopy.utils.SpoopyLogger;
import spoopy.utils.destroy.SpoopyDestroyable;
import spoopy.backend.native.SpoopyNativeCFFI;


/*
* CAREFUL: Do not de-allocate the gpu object regularaly!
* YOU MUST: Use the `destroy()` method to de-allocate the gpu object safely then `obj = null.`
*/

class SpoopyGPUObject implements ISpoopyDestroyable {
    @:noCompletion private var __pointer:SpoopyGPUObjectPointer;
    @:noCompletion private var __module:SpoopyGraphicsModule;

    public function new(flag:SpoopyFlags, module:SpoopyGraphicsModule) {

        // TODO: If OpenGL, then have an actual pointer static function.
        switch(flag) {
            case SEMAPHORE:
                __pointer = SpoopyNativeCFFI.spoopy_create_semaphore();
            default:
                SpoopyLogger.warn("Invalid flag for GPU object creation.");
        }
    }

    public function destroy():Void {
        __module.enqueueDeletionObj(this, __module.frameCount);
    }

    @:allow(spoopy.graphics.modules.SpoopyEntry)
    @:noCompletion private inline function flush():Void {
        __pointer = null;
    }
}

// TODO: If OpenGL, then have an actual pointer class.
typedef SpoopyGPUObjectPointer = Dynamic;