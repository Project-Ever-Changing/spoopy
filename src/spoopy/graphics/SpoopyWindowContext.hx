package spoopy.graphics;

import spoopy.graphics.SpoopyAccessFlagBits;
import spoopy.graphics.SpoopyPipelineStageFlagBits;
import spoopy.window.IWindowHolder;

import lime.math.Rectangle;
import lime.ui.Window;

/*
* TODO: Implement viewport and scissor scaling, so this class is pretty much useless.
*
* This class is only useful because it does some basic measurements for display sizing.
* All of the more important stuff is handled by the state manager or state.
*/

@:access(lime.ui.Window)
class SpoopyWindowContext implements IWindowHolder {
    public var module(get, never):SpoopyGraphicsModule;
    public var window(get, never):Window;

    public var displayWidth(default, null):Int = 0;
    public var displayHeight(default, null):Int = 0;

    @:noCompletion private var __window:Window;
    @:noCompletion private var __module:SpoopyGraphicsModule;
    @:noCompletion private var __viewportRect:Rectangle;
    @:noCompletion private var __attributeWidth:Int;
    @:noCompletion private var __attributeHeight:Int;

    public function new(module:SpoopyGraphicsModule, window:Window) {
        __window = window;
        __module = module;

        __attributeWidth = Std.int(window.__attributes.width);
        __attributeHeight = Std.int(window.__attributes.height);

        __viewportRect = new Rectangle();
    }

    @:allow(spoopy.graphics.SpoopyGraphicsModule) private function onDestroy():Void {
        __module = null;
        __window = null;
    }

    public function resize():Void {
        var windowWidth = Std.int(__window.width * __window.scale);
		var windowHeight = Std.int(__window.height * __window.scale);

        __setViewport(windowWidth, windowHeight);
    }

    @:noCompletion private function __setViewport(width:Int, height:Int):Void {
        var newWidth = displayWidth;
        var newHeight = displayHeight;

        var windowWidth = Std.int(width * __window.scale);
        var windowHeight = Std.int(height * __window.scale);

        if(__attributeWidth == 0 || __attributeHeight == 0 || windowWidth == 0 || windowHeight == 0) {
            #if !spoopy_dpi_aware
            displayWidth = width;
            displayHeight = height;
            #else
            displayWidth = windowWidth;
            displayHeight = windowHeight;
            #end

            __viewportRect.setTo(0, 0, displayWidth, displayHeight);
        }else {
            var scaleX = windowWidth / __attributeWidth;
            var scaleY = windowHeight / __attributeHeight;

            var scale = Math.min(scaleX, scaleY);

            newWidth = Math.round(displayWidth * scale);
            newHeight = Math.round(displayHeight * scale);

            var offsetX = (windowWidth - newWidth) >> 1;
            var offsetY = (windowHeight - newHeight) >> 1;

            // No need to use the matrix, that's too much computation for something so simple.
            __viewportRect.setTo(offsetX, offsetY, newWidth, newHeight);
        }
    }

    @:noCompletion private function get_window():Window {
        return __window;
    }

    @:noCompletion private function get_module():SpoopyGraphicsModule {
        return __module;
    }
}
