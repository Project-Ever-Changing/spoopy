package spoopy.obj.geom;

import spoopy.obj.SpoopyObject;
import spoopy.math.SpoopyMath;

class SpoopyUV implements SpoopyObject {
    public var u:Float;
    public var v:Float;

    public function new(u:Float = 0, v:Float = 0) {
        set(u, v);
    }

    public inline function set(u:Float = 0, v:Float = 0):Void {
        this.u = u;
        this.v = v;
    }

    public inline function destroy():Void {
        this.u = 0;
        this.v = 0;
    }

    public inline function copy():SpoopyUV {
        return new SpoopyUV(u, v);
    }

    public function toString():String {
        return '{u: ${SpoopyMath.fmt(u)} | v: ${SpoopyMath.fmt(v)}}';
    }
}