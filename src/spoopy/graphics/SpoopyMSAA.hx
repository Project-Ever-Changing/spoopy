package spoopy.graphics;

#if (haxe_ver >= 4.0) enum #else @:enum #end abstract SpoopyMSAA(Int) from Int to Int {
    public var NONE:Int = 1;
    public var MSAA2x:Int = 2;
    public var MSAA4x:Int = 4;
    public var MSAA8x:Int = 8;
}