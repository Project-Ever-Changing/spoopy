package spoopy.graphics.modules;

import spoopy.utils.SpoopyLogger;
import spoopy.utils.destroy.SpoopyDestroyable;
import spoopy.backend.SpoopyStaticBackend;
import spoopy.graphics.SpoopyMSAA;

import lime.ui.Window;

/*
* CAREFUL: Do not de-allocate the gpu object regularly!
* YOU MUST: Use the `destroy()` method to de-allocate the gpu object then `obj = null.`
*/

@:access(lime.ui.Window)
class SpoopyGPUObject implements ISpoopyDestroyable {
    @:noCompletion private var __flag:SpoopyFlags;
    @:noCompletion private var __pointer:SpoopyGPUObjectPointer;
    @:noCompletion private var __module:SpoopyGraphicsModule;

    public var flag(get, never):SpoopyFlags;

    public function new(flag:SpoopyFlags, module:SpoopyGraphicsModule) {
        __module = module;
        __flag = flag;

        // TODO: If OpenGL, then have an actual pointer static function.
        switch(flag) {
            case SEMAPHORE:
                __pointer = SpoopyStaticBackend.spoopy_create_semaphore();

            case RENDER_PASS:
                __pointer = SpoopyStaticBackend.spoopy_create_render_pass(
                    SpoopyMSAA.NONE, // TODO: Make this actually configurable by the user or dev.
                    module.__context.window.__backend.handle
                );

            case PIPELINE:
                /* WIP */

            default:
                SpoopyLogger.warn("Invalid flag for GPU object creation.");
        }
    }

    public function create():Void {
        switch(flag) {
            case SEMAPHORE:
                SpoopyStaticBackend.spoopy_recreate_semaphore(__pointer);

            case RENDER_PASS:
                SpoopyStaticBackend.spoopy_recreate_render_pass(__pointer);

            case PIPELINE:
                /* WIP */

            default:
                SpoopyLogger.warn("Invalid flag for GPU object recreation.");
        }
    }

    public function destroy():Void {
        if(__pointer != null) __module.enqueueDeletionObj(this, __module.frameCount);
    }

    @:allow(spoopy.graphics.modules.SpoopyEntry)
    @:noCompletion private inline function flush():Void {
        SpoopyStaticBackend.spoopy_dealloc_gpu_cffi_pointer(__flag, __pointer);
        __pointer = null;

        #if spoopy_debug
        SpoopyLogger.success("De-allocated GPU object with flag: " + __flag);
        #end
    }

    @:noCompletion private function get_flag():SpoopyFlags {
        return __flag;
    }
}

// TODO: If OpenGL, then have an actual pointer class.
typedef SpoopyGPUObjectPointer = Dynamic;