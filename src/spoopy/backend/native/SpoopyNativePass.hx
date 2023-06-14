package spoopy.backend.native;

class SpoopyNativePass {
    public var handle:Dynamic;

    public function new() {
        handle = SpoopyNativeCFFI.spoopy_create_render_pass();
    }

    public function addColorAttachment(location:Int, format:Int) {
        SpoopyNativeCFFI.spoopy_add_color_attachment(handle, location, format);
    }

    public function addDepthAttachment(location:Int, format:Int) {
        SpoopyNativeCFFI.spoopy_add_depth_attachment(handle, location, format);
    }
}