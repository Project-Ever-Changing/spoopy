package spoopy.app.graphics;

import openfl.display.StageDisplayState;
import lime.math.Rectangle;
import lime.math.Matrix3;

/*
* The stage is the main container for all the graphics.
*/

class Stage {
    public var allowsFullScreen(default, null):Bool;


    @:noCompletion private var __color:Int;
    @:noCompletion private var __colorSplit:Array<Float>;
    @:noCompletion private var __colorString:String;
    @:noCompletion private var __contentsScaleFactor:Float;
    @:noCompletion private var __currentTabOrderIndex:Int;
    @:noCompletion private var __deltaTime:Int;
    @:noCompletion private var __displayState:StageDisplayState;
    @:noCompletion private var __mouseX:Float;
	@:noCompletion private var __mouseY:Float;
    @:noCompletion private var __lastClickTime:Int;
    @:noCompletion private var __logicalWidth:Int;
	@:noCompletion private var __logicalHeight:Int;
    @:noCompletion private var __matrix:Matrix3;
    @:noCompletion private var __rect:Rectangle;


    public function new() {
        __color = 0xFFFFFFFF;
        __colorSplit = [0xFF, 0xFF, 0xFF];
        __colorString = "#FFFFFF";
        __contentsScaleFactor = 1.0;
        __currentTabOrderIndex = 0;
        __deltaTime = 0;
        __displayState = StageDisplayState.NORMAL;
        __mouseX = 0;
        __mouseY = 0;
        __lastClickTime = 0;
        __logicalWidth = 0;
        __logicalHeight = 0;
        __matrix = new Matrix3();
        __rect = new Rectangle();

        allowsFullScreen = true;
    }
}