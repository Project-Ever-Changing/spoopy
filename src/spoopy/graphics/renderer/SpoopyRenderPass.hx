package spoopy.graphics.renderer;

import spoopy.graphics.SpoopyFormat;

class SpoopyRenderPass {

    @:noCompletion private var __location:Int = 0;

    public function new() {
        
    }

    public function addColorAttachment(format:SpoopyFormat) {

        __location++;
    }
}

#if spoopy_vulkan
typedef SpoopyRenderPass = 
#end