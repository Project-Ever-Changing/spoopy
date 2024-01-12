package spoopy.graphics.renderer;

import spoopy.graphics.SpoopyFormat;
import spoopy.graphics.SpoopyAccessFlagBits;
import spoopy.graphics.SpoopyPipelineStageFlagBits;
import spoopy.graphics.modules.SpoopyGPUObject;

class SpoopyRenderPass extends SpoopyGPUObject {
    @:allow(spoopy.graphics.SpoopyGraphicsModule) private var __hasImageLayout:Bool = false;

    @:noCompletion #if haxe4 final #else @:final var #end __sampled:Bool;


    @:noCompletion private var __attachments:Map<Int, SpoopyFormat>;
    @:noCompletion private var __stencilAttachments:Map<Int, Bool>;
    @:noCompletion private var __backend:SpoopyBackendPass;
    @:noCompletion private var __colorCount:Int = 0;
    @:noCompletion private var __depthCount:Int = 0;

    public function new(module:SpoopyGraphicsModule, sampled:Bool = false) {
        super(RENDER_PASS, module);

        __attachments = new Map<Int, SpoopyFormat>();
        __stencilAttachments = new Map<Int, Bool>();
        __backend = new SpoopyBackendPass();

        __sampled = sampled;
    }

    public function getSampled():Bool {
        return __sampled;
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

    public function addSubpassDependency(has_external1:Bool, has_external2:Bool,
    srcStageMask:SpoopyPipelineStageFlagBits, dstStageMask:SpoopyPipelineStageFlagBits,
    srcAccessMask:SpoopyAccessFlagBits, dstAccessMask:SpoopyAccessFlagBits, dependencyFlags:Int):Void {
        __backend.addSubpassDependency(has_external1, has_external2, srcStageMask, dstStageMask, srcAccessMask, dstAccessMask, dependencyFlags);
    }

    public function createSubpass():Void {
        __backend.createSubpass();
    }

    public function processAttachments():Void {
        for(i in 0...__colorCount) {
            __backend.addColorAttachment(i, __attachments.get(i), __hasImageLayout, __sampled);
        }

        for(i in __colorCount...(__colorCount + __depthCount)) {
            __backend.addDepthAttachment(i, __attachments.get(i), __stencilAttachments.get(i - __colorCount), __sampled);
        }

        __attachments.clear();
        __stencilAttachments.clear();

        __colorCount = 0;
        __depthCount = 0;
    }

    public static function getFormatFromColorDepth(colorDepth:Int):SpoopyFormat {
        switch (colorDepth) {
            case 8:
                return R8_UNORM;
            case 16:
                return B5G6R5_UNORM_PACK16; // Assumes B5G6R5
            case 24:
                return B8G8R8_UNORM;
            default:
                return B8G8R8A8_UNORM;
        }
    }
}

#if spoopy_vulkan
typedef SpoopyBackendPass = spoopy.backend.native.SpoopyNativePass;
#end