package spoopy.graphics;

import spoopy.graphics.renderer.SpoopyRenderPass;
import spoopy.graphics.renderer.SpoopyRenderPass;
import spoopy.graphics.SpoopyAccessFlagBits;
import spoopy.graphics.SpoopyPipelineStageFlagBits;

import lime.math.Rectangle;
import lime.math.Matrix3;
import lime.math.Vector2;
import lime.ui.Window;

/*
* TODO: This class is a mess. It's a mess because I'm not sure how to handle DPI scaling.
* I also have yet to implement viewport and scissor scaling, so this class is pretty much useless.
*/

@:access(lime.ui.Window)
@:access(spoopy.graphics.renderer.SpoopyRenderPass)
class SpoopyWindowDisplay {
    public var displayWidth(default, null):Int = 0;
    public var displayHeight(default, null):Int = 0;

    @:noCompletion private var __window:Window;
    @:noCompletion private var __renderPass:SpoopyRenderPass;
    @:noCompletion private var __displayMatrix:Matrix3;
    @:noCompletion private var __viewportRect:Rectangle;

    public function new(window:Window) {
        __window = window;
        __displayMatrix = new Matrix3();
        __viewportRect = new Rectangle();
    }

    public function resize():Void {
        var windowWidth = Std.int(__window.width * __window.scale);
		var windowHeight = Std.int(__window.height * __window.scale);

        __setViewport(windowWidth, windowHeight);
    }

    @:noCompletion private function __setViewport(width:Int, height:Int):Void {
        displayWidth = width;
        displayHeight = height;

        #if !spoopy_dpi_aware
        displayWidth = Math.round(displayWidth / __window.scale);
        displayHeight = Math.round(displayHeight / __window.scale);

        __displayMatrix.identity();
        __displayMatrix.scale(__window.scale, __window.scale);
        #end

        __viewportRect.setTo(
            __displayMatrix.tx,
            __displayMatrix.ty,
            displayWidth * __displayMatrix.a + __displayMatrix.tx, // Matrix transformation X
            displayHeight * __displayMatrix.d + __displayMatrix.ty // Matrix transformation Y
        );
    }

    private inline function createRenderPass():Void {
        if(__renderPass != null) {
            return;
        }

        var attributes = __window.__attributes.context;

        __renderPass = new SpoopyRenderPass();
        __renderPass.__hasImageLayout = true;
        __renderPass.addColorAttachment(SpoopyRenderPass.getFormatFromColorDepth(attributes.colorDepth));

        // Subpass dependency for color attachment
        __renderPass.addSubpassDependency(true, false, COLOR_ATTACHMENT_OUTPUT_BIT, COLOR_ATTACHMENT_OUTPUT_BIT,
            MEMORY_READ_BIT, COLOR_ATTACHMENT_READ_BIT | COLOR_ATTACHMENT_WRITE_BIT, 0);

        if(attributes.hardware) {
            if(attributes.depth) {
                var format:SpoopyFormat = attributes.stencil ? SpoopyFormat.D32_SFLOAT_S8_UINT : SpoopyFormat.D32_SFLOAT;
                __renderPass.addDepthAttachment(format, attributes.stencil);

                __renderPass.addSubpassDependency(true, false, LATE_FRAGMENT_TESTS_BIT, LATE_FRAGMENT_TESTS_BIT,
                    MEMORY_READ_BIT, DEPTH_STENCIL_ATTACHMENT_READ_BIT | DEPTH_STENCIL_ATTACHMENT_WRITE_BIT, 0);
            }
        }

        __renderPass.processAttachments();
        __renderPass.createSubpass();
        __renderPass.createRenderpass();
    }
}