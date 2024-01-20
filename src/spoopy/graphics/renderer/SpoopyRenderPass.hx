package spoopy.graphics.renderer;

import spoopy.graphics.SpoopyFormat;
import spoopy.graphics.SpoopyAccessFlagBits;
import spoopy.graphics.SpoopyPipelineStageFlagBits;
import spoopy.graphics.modules.SpoopyGPUObject;

class SpoopyRenderPass extends SpoopyGPUObject {
    public function new(module:SpoopyGraphicsModule) {
        super(RENDER_PASS, module);
    }
}