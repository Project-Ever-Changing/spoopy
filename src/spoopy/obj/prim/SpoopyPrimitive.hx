package spoopy.obj.prim;

import spoopy.obj.SpoopyCamera;
import spoopy.obj.geom.SpoopyUV;
import spoopy.obj.geom.SpoopyPoint;
import spoopy.obj.display.SpoopyVertexObject;
import spoopy.util.SpoopyFloatBuffer;

import lime.math.Vector4;

class SpoopyPrimitive implements SpoopyVertexObject {

    /*
    * If `update()` is automatically called;
    */
    public var active(default, set):Bool = true;

    /*
    * If `render()` is automatically called.
    */
    public var visible(default, set):Bool = true;

    /*
    * Whether `update()` and `render()` are automatically called.
    */
    public var inScene(default, set):Bool = true;

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

    @:noCompletion var __vertices:SpoopyFloatBuffer;
    @:noCompletion var __cameras:Array<SpoopyCamera>;

    public function new(vertices:Array<SpoopyPoint>) {
        this.vertices = vertices;

        __cameras = [];
    }

    public function setCamera(cam:SpoopyCamera):Void {
        draw(cam);
        __cameras.push(cam);
    }

    public function removeCamera(cam:SpoopyCamera):Void {
        __cameras.remove(cam);

        if(__vertices == null) {
            return;
        }

        cam.removeBuffer(__vertices);
    }

    public function draw(cam:SpoopyCamera):Void {
        removeCamera(cam);

        var vertexLength:Int = vertices.length * 3;
        vertexLength = (normal != null) ? vertexLength + normal.length * 3 : vertexLength;
        vertexLength = (tangents != null) ? vertexLength + tangents.length * 3 : vertexLength;
        vertexLength = (uvs != null) ? vertexLength + uvs.length * 2 : vertexLength;
        vertexLength = (colors != null) ? vertexLength + colors.length * 4 : vertexLength;

        __vertices = new SpoopyFloatBuffer(vertexLength);

        for(i in 0...vertices.length) {
            var b = vertices[i];
            __vertices.set(__vertices, [b.x, b.y, b.z], i * 3);

            if(normal != null) {
                var n = normal[i];
                __vertices.set(__vertices, [n.x, n.y, n.z], i * 3);
            }

            if(tangents != null) {
                var t = tangents[i];
                __vertices.set(__vertices, [t.x, t.y, t.z], i * 3);
            }

            if(uvs != null) {
                var u = uvs[i];
                __vertices.set(__vertices, [u.u, u.v], i * 2);
            }

            if(colors != null) {
                var c = colors[i];
                __vertices.set(__vertices, [c.x, c.y, c.z, c.w], i * 4);
            }
        }

        if(!inScene || !visible) {
            return;
        }

        cam.storeBuffer(__vertices);
    }

    public function getSourceVertices():SpoopyFloatBuffer {
        return __vertices;
    }

    public function render():Void {
        /*
        * Empty.
        */
    }

    public function update(elapsed:Float):Void {
        /*
        * Empty.
        */
    }
    
    public function destroy():Void {
        inScene = false;

        __cameras = null;
        vertices = null;
    }

    public function toString() {
		return Type.getClassName(Type.getClass(this)).split(".").pop();
	}

    @:noCompletion function set_active(value:Bool):Bool {
        return active = value;
    }

    @:noCompletion function set_visible(value:Bool):Bool {
        if(value) {
            for(cam in __cameras) {
                cam.storeBuffer(__vertices);
            }
        }else {
            for(cam in __cameras) {
                cam.removeBuffer(__vertices);
            }
        }

        return visible = value;
    }

    @:noCompletion function set_inScene(value:Bool):Bool {
        return inScene = value;
    }
}