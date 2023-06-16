package spoopy.graphics.renderer;

import spoopy.graphics.SpoopyFormat;

class SpoopyRenderPass {
    @:allow(spoopy.graphics.SpoopyGraphicsModule) private var __hasImageLayout:Bool = false;


    @:noCompletion private var __attachments:Map<Int, SpoopyFormat>;
    @:noCompletion private var __stencilAttachments:Map<Int, Bool>;
    @:noCompletion private var __backend:SpoopyBackendPass;
    @:noCompletion private var __colorCount:Int = 0;
    @:noCompletion private var __depthCount:Int = 0;

    public function new() {
        __attachments = new Map<Int, SpoopyFormat>();
        __stencilAttachments = new Map<Int, Bool>();
        __backend = new SpoopyBackendPass();
    }

    public function addColorAttachment(format:SpoopyFormat):Void {
        __attachments.set(__colorCount, format);
        __colorCount++;
    }

    /*
    * Depth attachments MUST BE added after color attachments.
    */
    public function addDepthAttachment(format:SpoopyFormat, hasStencil:Bool):Void {
        __attachments.set(__colorCount + __depthCount, format);
        __stencilAttachments.set(__depthCount, hasStencil);
        __depthCount++;
    }

    public function processAttachments():Void {
        for(i in 0...__colorCount) {
            __backend.addColorAttachment(i, __attachments.get(i), __hasImageLayout);
        }

        for(i in __colorCount...(__colorCount + __depthCount)) {
            __backend.addDepthAttachment(i, __attachments.get(i), __stencilAttachments.get(i - __colorCount));
        }

        __attachments.clear();
        __stencilAttachments.clear();

        __colorCount = 0;
        __depthCount = 0;
    }

    public static function getFormatFromColorDepth(colorDepth:Int):SpoopyFormat {
        switch (colorDepth) {
            case 16:
                return R5G6B5_UNORM_PACK16; // Assumes RGB565
            case 24:
                return R8G8B8_UNORM;
            case 32:
                return R8G8B8A8_UNORM;
            case 64:
                return R16G16B16A16_UNORM; // Assumes RGBA
            case 128:
                return R32G32B32A32_SFLOAT; // Assumes RGBA
            default:
                return R8_UNORM;
        }
    }
}

#if spoopy_vulkan
typedef SpoopyBackendPass = spoopy.backend.native.SpoopyNativePass;
#end