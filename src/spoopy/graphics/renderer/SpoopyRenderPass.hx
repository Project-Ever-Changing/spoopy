package spoopy.graphics.renderer;

import spoopy.backend.native.SpoopyNativePass;
import spoopy.graphics.SpoopyFormat;

#if lime
import lime.graphics.PixelFormat;
#end

class SpoopyRenderPass {
    @:noCompletion private var __attachments:Map<Int, SpoopyFormat>;
    @:noCompletion private var __backend:SpoopyRenderPass;
    @:noCompletion private var __colorCount:Int = 0;
    @:noCompletion private var __depthCount:Int = 0;

    public function new() {
        __attachments = new Map<Int, SpoopyFormat>();
        __backend = new SpoopyNativePass();
    }

    public function addColorAttachment(format:SpoopyFormat):Void {
        __attachments.set(__colorCount, format);
        __colorCount++;
    }

    /*
    * Depth attachments MUST BE added after color attachments.
    */
    public function addDepthAttachment(format:SpoopyFormat):Void {
        __attachments.set(__colorCount + __depthCount, format);
        __depthCount++;
    }

    public function processAttachments():Void {
        for(i in 0...__colorCount) {
            __backend.addColorAttachment(__attachments.get(i));
        }

        for(i in __colorCount...(__colorCount + __depthCount)) {
            __backend.addDepthAttachment(__attachments.get(i));
        }
    }

    public static function getFormatFromPixelFormat(pixelFormat:Int):SpoopyFormat {
        #if lime
        switch(pixelFormat) {
            case PixelFormat.BGRA32:
                return B8G8R8A8_UNORM;
            case PixelFormat.ARGB32:
                return A8B8G8R8_UNORM_PACK32;
            default:
                return R8G8B8A8_UNORM;
        }
        #else
        return R8G8B8A8_UNORM;
        #end
    }
}

#if spoopy_vulkan
typedef SpoopyRenderPass = spoopy.backend.native.SpoopyNativePass;
#end