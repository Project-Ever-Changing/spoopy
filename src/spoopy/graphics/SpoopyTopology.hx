package spoopy.graphics;

#if (haxe_ver >= 4.0) enum #else @:enum #end abstract SpoopyTopology(Int) from Int to Int from UInt to UInt {
    public var Unknown = 0;
    public var PointList = 1;
    public var LineList = 2;
    public var TriangleList = 3;
    public var PatchList = 4;
}