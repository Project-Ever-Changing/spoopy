package spoopy.obj.prim;

import spoopy.obj.SpoopyCamera;
import spoopy.obj.geom.SpoopyPoint;
import spoopy.obj.display.SpoopyDisplayObject;
import spoopy.util.SpoopyFloatBuffer;

class SpoopyPrimitive implements SpoopyDisplayObject {

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
    * NOTE: changing any value from this array won't update anything. Use `alloc` for modifying purposes.
    */
    public var vertices:Array<SpoopyPoint>;

    @:noCompletion var __cameras:Array<SpoopyCamera>;
    //@:noCompletion var __bufferCache:Map<Int, SpoopyFloatBuffer>;
    @:noCompletion var __lengthCache:Int = 0;

    public function new() {
        __cameras = [];
        __verticesCache = [];

        //__bufferCache = new Map<Int, SpoopyFloatBuffer>();

        alloc();
    }

    public function alloc():Void {
        if(vertices == null) {
            return;
        }

        var __vertices:SpoopyFloatBuffer = new SpoopyFloatBuffer();

        for(i in 0...vertices.length) {
            var b = vertices[i];

            __vertices.push(b.x);
            __vertices.push(b.y);
            __vertices.push(b.z);
        }

        //__bufferCache.set(0, __vertices);

        for(cam in cameras)
            cam.storeBuffer(__vertices, __lengthCache);

        __lengthCache = __vertices.length;
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
        __bufferCache.clear();

        inScene = false;
        __cameras = null;
        __bufferCache = null;

        vertices = null;
    }

    public function toString() {
		return Type.getClassName(Type.getClass(this)).split(".").pop();
	}

    @:noCompletion @:access(spoopy.obj.SpoopyCamera) function dealloc():Void {
        for(camera in __cameras) {

        }
    }

    @:noCompletion function set_active(value:Bool):Bool {
        return active = value;
    }

    @:noCompletion function set_visible(value:Bool):Bool {
        return visible = value;
    }

    @:noCompletion function set_inScene(value:Bool):Bool {
        return inScene = value;
    }
}