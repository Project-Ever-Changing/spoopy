package spoopy.graphics;

import lime.math.Rectangle;
import lime.math.Matrix3;
import lime.ui.Window;

class SpoopyWindowDisplay {
    public var displayWidth(default, null):Int = 0;
    public var displayHeight(default, null):Int = 0;

    @:noCompletion private var __window:Window;
    @:noCompletion private var __displayMatrix:Matrix3;
    @:noCompletion private var __scissorRect:Rectangle;
    @:noCompletion private var __scissorOffsetX:Int = 0;
    @:noCompletion private var __scissorOffsetY:Int = 0;

    public function new(window:Window) {
        __window = window;
        __displayMatrix = new Matrix3();

        var windowWidth = Std.int(__window.width * __window.scale);
		var windowHeight = Std.int(__window.height * __window.scale);

        setViewport(windowWidth, windowHeight);
    }

    public function setViewport(width:Int, height:Int):Void {
        displayWidth = width;
        displayHeight = height;

        #if !spoopy_dpi_aware
        displayWidth = Math.round(displayWidth / __window.scale);
        displayHeight = Math.round(displayHeight / __window.scale);

        __displayMatrix.identity();
        __displayMatrix.scale(__window.scale, __window.scale);
        #end

        __displayMatrix.setTo(0, 0, displayWidth, displayHeight);
        __scissorRect = new Rectangle(0, 0, displayWidth, displayHeight);
        __scissorRect.offset(__scissorOffsetX, __scissorOffsetY);
    }
}