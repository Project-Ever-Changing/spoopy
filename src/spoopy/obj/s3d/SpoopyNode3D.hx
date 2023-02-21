package spoopy.obj.s3d;

import spoopy.obj.data.SpoopyRotationMode;
import spoopy.obj.geom.SpoopyPoint;

interface SpoopyNode3D {

    /*
    * The `rotationMode` variable stores an enumeration value that determines the type of rotation representation used.
    */
    var rotationMode(default, set):SpoopyRotationMode;

    /*
    * The 'scale' method determines the scaling factor for an object, which affects its size and proportion.
    */
    function scale(sx:Float, sy:Float, sz:Float):Void;

    /*
    * The `translate` method moves an object to a new location by changing its position coordinates.
    */
    function translate(dx:Float, dy:Float, dz:Float):Void;

    /*
    * The `lookAt` method orients the object to face a given target by rotating it.
    */
    function lookAt(targetPos:SpoopyPoint, up:SpoopyPoint = new SpoopyPoint(0, 1, 0)):Void;

    /*
    * The rotating methods rotate the object by the specified angle.
    */

    function rotateX(angle:Float):Void;
    function rotateY(angle:Float):Void;
    function rotateZ(angle:Float):Void;

    function rotate(point:SpoopyPoint, angle:Float):Void;
}