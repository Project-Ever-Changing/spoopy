package spoopy.graphics.modules;

import spoopy.utils.destroy.SpoopyDestroyable;

/*
* A wrapper for the wrappers to indicate the last frame before the object was deleted.
*/

class SpoopyEntry implements ISpoopyDestroyable {
    #if haxe4 public final frameCounter:Int; #else @:final public var frameCounter:Int; #end
    public var item(default, null):ISpoopyDestroyable;

    @:noCompletion private var __handle:SpoopyBackendEntry;

    public function new(frameCounter:Int, item:ISpoopyDestroyable) {
        this.frameCounter = frameCounter;
        this.item = item;

        // TODO: If OpenGL, then have an actual constructor.
    }

    public function destroy() {
        
    }
}

// TODO: If OpenGL, then have an actual handle class.
typedef SpoopyBackendEntry = Dynamic;