package spoopy.obj.display;

import spoopy.util.SpoopyFloatBuffer;
import spoopy.obj.geom.SpoopyPoint;
import spoopy.obj.geom.SpoopyUV;

import lime.math.Vector4;

interface SpoopyVertexObject extends SpoopyDisplayObject {
    /*
    * The `vertices` holds an array of points that define the shape of the primitive.
    * NOTE: changing any value from this array won't update anything.
    */
    public var vertices(default, null):Array<SpoopyPoint>;

    /*
    * The `normal` property holds a vector that defines the orientation of the primitive's surface.
    * NOTE: changing any value from this array won't update anything.
    */
    public var normal(default, null):Array<SpoopyPoint>;

    /*
    * The `tangents` property holds an array of tangent vectors that define the direction of the surface tangent at each vertex of the primitive.
    * NOTE: changing any value from this array won't update anything.
    */
    public var tangents(default, null):Array<SpoopyPoint>;

    /*
    * The `uvs` property holds an array of UV coordinates that define the location of the texture applied to each vertex of the primitive.
    * NOTE: changing any value from this array won't update anything.
    */
    public var uvs(default, null):Array<SpoopyUV>;

    /*
    * The `color` property holds a value that defines the color of the primitive.
    * NOTE: changing any value from this array won't update anything.
    */
    public var colors(default, null):Array<Vector4>;

    /*
    * Retrieves a set of vertex data in the form of a float buffer.
    */
    function getSourceVertices():SpoopyFloatBuffer;
}