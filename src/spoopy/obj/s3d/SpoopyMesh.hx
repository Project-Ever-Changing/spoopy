package spoopy.obj.s3d;

import spoopy.util.SpoopyFloatBuffer;
import spoopy.obj.prim.SpoopyPrimitive;
import spoopy.obj.data.SpoopyRotationMode;
import spoopy.obj.geom.SpoopyCallbackPoint;
import spoopy.obj.geom.SpoopyPoint;

class SpoopyMesh extends SpoopyPrimitive implements SpoopyNode3D {
    /*
    * The `rotationMode` variable stores an enumeration value that determines the type of rotation representation used.
    */
    public var rotationMode(default, set):SpoopyRotationMode;

    public var size(default, null):SpoopyCallbackPoint;
    public var position(default, null):SpoopyCallbackPoint;

    public var angle_x(default, null):Float = 0;
    public var angle_y(default, null):Float = 0;
    public var angle_z(default, null):Float = 0;

    public function new(vPoints:Array<SpoopyPoint>, iPoints:Array<SpoopyPoint>) {
        super();

        vertices = new SpoopyFloatBuffer(vPoints);
        indices = new SpoopyFloatBuffer(iPoints);

        size = new SpoopyCallbackPoint(1, 1, 1);
        position = new SpoopyCallbackPoint(0, 0, 0);

        size.callback = __scale;
        position.callback = __translate;
        angle.callback = __rotation;
    }

    public function rotate(point:SpoopyPoint, angle:Float):Void {
        
    }

    @:noCompletion function __scale(x:Float, y:Float, z:Float):Void {

    }

    @:noCompletion function __translate(x:Float, y:Float, z:Float):Void {

    }

    @:noCompletion function __rotation(x:Float, y:Float, z:Float):Void {

    }

    @:noCompletion function set_rotationMode(value:SpoopyRotationMode):SpoopyRotationMode {
        return rotationMode = value;
    }
}