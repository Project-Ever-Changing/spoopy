package spoopy.backend.native;

class SpoopyNativeGraphics {
    public function new() {
        // Empty
    }

    public function check():Void {
        SpoopyNativeCFFI.spoopy_check_graphics_module();
    }

    public function update():Void {
        SpoopyNativeCFFI.spoopy_update_graphics_module();
    }
}