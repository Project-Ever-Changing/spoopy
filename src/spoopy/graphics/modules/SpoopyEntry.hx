package spoopy.graphics.modules;

import spoopy.window.IWindowHolder;
import spoopy.graphics.SpoopyGraphicsModule;
import spoopy.backend.native.SpoopyNativeCFFI;
import spoopy.utils.destroy.SpoopyDestroyable;
import spoopy.app.SpoopyApplication;

/*
* A wrapper for the wrappers to indicate the last frame before the object was deleted.
*/

@:access(lime.ui.Window)
class SpoopyEntry implements ISpoopyDestroyable {
    #if haxe4 public final frameCounter:Int; #else @:final public var frameCounter:Int; #end
    public var item(default, null):SpoopyGPUObject;

    @:noCompletion private var __module:SpoopyGraphicsModule;
    @:noCompletion private var __handle:SpoopyBackendEntry;

    public function new(module:SpoopyGraphicsModule, holder:IWindowHolder, frameCounter:Int, item:SpoopyGPUObject) {
        this.__module = module;
        this.frameCounter = frameCounter;
        this.item = item;

        // TODO: If OpenGL, then have an actual constructor.
        __handle = SpoopyNativeCFFI.spoopy_create_entry(holder.window.__backend.handle);
    }

    public function destroy() {
        var checkFrame = __module.frameCount - SpoopyEngine.NUM_FRAMES_WAIT_UNTIL_DELETE;

        if(checkFrame > frameCounter && isGPUOperationComplete()) {
            item.flush();
            item = null;
        }

        if(item != null) {
            item.destroy();
        }
    }

    private inline function isGPUOperationComplete():Bool {
        
        // TODO: If OpenGL, then have an actual method.
        return SpoopyNativeCFFI.spoopy_entry_is_gpu_operation_complete(__handle);
    }
}

// TODO: If OpenGL, then have an actual handle class.
typedef SpoopyBackendEntry = Dynamic;