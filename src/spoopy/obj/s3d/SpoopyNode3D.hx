package spoopy.obj.s3d;

import spoopy.obj.data.SpoopyRotationMode;
import spoopy.obj.geom.SpoopyPoint;

interface SpoopyNode3D {

    /*
    * The `rotationMode` variable stores an enumeration value that determines the type of rotation representation used.
    */
    var rotationMode(default, set):SpoopyRotationMode;

    /*
    * The `lookAt` method orients the object to face a given target by rotating it.
    */
    function lookAt(targetPos:SpoopyPoint, up:SpoopyPoint = new SpoopyPoint(0, 1, 0)):Void;

    /*
    * The rotating methods rotate the object by the specified angle.
    */
    function rotate(point:SpoopyPoint, angle:Float):Void;
}