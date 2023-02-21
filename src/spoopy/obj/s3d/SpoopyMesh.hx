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

    public var size:SpoopyCallbackPoint;
    public var position:SpoopyCallbackPoint;

    public function new(vPoints:Array<SpoopyPoint>, iPoints:Array<SpoopyPoint>) {
        super();

        vertices = new SpoopyFloatBuffer(vPoints);
        indices = new SpoopyFloatBuffer(iPoints);

        size = new SpoopyCallbackPoint(1, 1, 1);
        position = new SpoopyCallbackPoint(0, 0, 0);
    }

    @:noCompletion function set_rotationMode(value:SpoopyRotationMode):SpoopyRotationMode {
        return rotationMode = value;
    }
}