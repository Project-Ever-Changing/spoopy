package spoopy.app.graphics;

/*
* The stage is the main container for all the graphics.
*/

class Stage {
    @:noCompletion private var __color:Int;
    @:noCompletion private var __colorSplit:Array<Float>;
    @:noCompletion private var __colorString:String;
    @:noCompletion private var __contentsScaleFactor:Float;
    @:noCompletion private var __currentTabOrderIndex:Int;
    @:noCompletion private var __deltaTime:Int;

    public function new() {
        __color = 0xFFFFFFFF;
        __colorSplit = [0xFF, 0xFF, 0xFF];
        __colorString = "#FFFFFF";
        __contentsScaleFactor = 1.0;
        __currentTabOrderIndex = 0;
        __deltaTime = 0;
    }
}