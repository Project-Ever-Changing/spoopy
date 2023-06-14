package spoopy.graphics.renderer;

import spoopy.backend.native.SpoopyNativePass;
import spoopy.graphics.SpoopyFormat;

class SpoopyRenderPass {

    @:noCompletion private var __backend:SpoopyRenderPass;
    @:noCompletion private var __location:Int = 0;

    public function new() {
        __backend = new SpoopyNativePass();
    }

    public function addColorAttachment(format:SpoopyFormat) {
        __backend.addColorAttachment(__location, format);
        __location++;
    }

    public function addDepthAttachment(format:SpoopyFormat) {
        __backend.addDepthAttachment(__location, format);
        __location++;
    }
}

#if spoopy_vulkan
typedef SpoopyRenderPass = spoopy.backend.native.SpoopyNativePass;
#end