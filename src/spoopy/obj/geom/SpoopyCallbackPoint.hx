package spoopy.obj.geom;

class SpoopyCallbackPoint extends SpoopyPoint {
    public var callback:Float->Float->Float->Void;

    public function new(x:Float = 0, y:Float = 0, z:Float = 0) {
        super(x, y, z);
    }

    @:noCompletion override function set_x(value:Float):Float {
        callback(value, y, z);
        return this.x = value;
    }

    @:noCompletion override function set_y(value:Float):Float {
        callback(x, value, z);
        return this.y = value;
    }

    @:noCompletion override function set_z(value:Float):Float {
        callback(x, y, value);
        return this.z = value;
    }
}