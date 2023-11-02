package spoopy.graphics.modules;

#if (haxe_ver >= 4.0) enum #else @:enum #end abstract SpoopyFlags(Int) from Int to Int from UInt to UInt {
    public var SEMAPHORE = 0;
}