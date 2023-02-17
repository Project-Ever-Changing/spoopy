package spoopy.obj.display;

import spoopy.obj.SpoopyObject;

interface SpoopyDisplayObject extends SpoopyObject {

    /*
    * If `update()` is automatically called;
    */
    var active(default, set):Bool;

    /*
    * If `render()` is automatically called.
    */
    var visible(default, set):Bool;

    /*
    * Whether `update()` and `render()` are automatically called.
    */
    var inScene(default, set):Bool;

    /*
    * Called by each render tick. 
    */
    function render():Void;

    /*
    * Called by each update tick.
    */
    function update(elapsed:Float):Void;
}