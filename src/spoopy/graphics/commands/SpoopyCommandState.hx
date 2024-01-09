package spoopy.graphics.commands;

#if (haxe_ver >= 4.0) enum #else @:enum #end abstract SpoopyCommandState (Int) from Int to Int from UInt to UInt {
    public var WAITING_FOR_BEGIN:Int = 0;
    public var HAS_BEGUN:Int = 1;
    public var INSIDE_RENDER_PASS:Int = 2;
    public var HAS_ENDED:Int = 3;
    public var SUBMITTED:Int = 4;
    public var DESTROYED:Int = 5;
}