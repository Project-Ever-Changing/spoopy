package spoopy.graphics;

import lime.math.Rectangle;
import lime.math.Matrix3;
import lime.math.Vector2;
import lime.ui.Window;

/*
* TODO: This class is a mess. It's a mess because I'm not sure how to handle DPI scaling.
* I also have yet to implement viewport and scissor scaling, so this class is pretty much useless.
*/

class SpoopyWindowDisplay {
    public var displayWidth(default, null):Int = 0;
    public var displayHeight(default, null):Int = 0;

    @:noCompletion private var __window:Window;
    @:noCompletion private var __displayMatrix:Matrix3;
    @:noCompletion private var __viewportRect:Rectangle;

    public function new(window:Window) {
        __window = window;
        __displayMatrix = new Matrix3();
        __viewportRect = new Rectangle();

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

        __viewportRect.setTo(
            __displayMatrix.tx,
            __displayMatrix.ty,
            displayWidth * __displayMatrix.a + __displayMatrix.tx, // Matrix transformation X
            displayHeight * __displayMatrix.d + __displayMatrix.ty // Matrix transformation Y
        );
    }
}