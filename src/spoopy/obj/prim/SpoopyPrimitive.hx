package spoopy.obj.prim;

import spoopy.obj.geom.SpoopyPoint;
import spoopy.obj.display.SpoopyDisplayObject;
import spoopy.util.SpoopyFloatBuffer;
import spoopy.SpoopyCamera;

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
    */
    private var vertices(default, set):Array<SpoopyPoint>;

    /*
    * The `indices` of the vertices that form the primitive.
    */
    private var indices(default, set):Array<SpoopyPoint>;

    @:noCompletion var __cameras:Array<SpoopyCamera>;

    @:noCompletion var __vertices:Array<SpoopyPoint>;
    @:noCompletion var __indices:Array<SpoopyPoint>;

    public function new() {
        __cameras = [];
        __vertices = [];
        __indices = [];
    }

    public function render():Void {
        /*
        * Empty.
        */
        if(visible && inScene && !(__vertices == vertices) && ) {

        }
    }

    public function update(elapsed:Float):Void {
        /*
        * Empty.
        */
    }
    
    public function clear():Void {
        inScene = false;
        __cameras = null;
    }

    public function toString() {
		return Type.getClassName(Type.getClass(this)).split(".").pop();
	}

    @:noCompletion function allocPoints():Void {
        for(camera in __cameras) {

        }
    }

    @:noCompletion function deallocPoints():Void {
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

    @:noCompletion function set_vertices(value:Array<SpoopyPoint>):Array<SpoopyPoint> {
        return vertices = value;
    }

    @:noCompletion function set_indices(value:Array<SpoopyPoint>):Array<SpoopyPoint> {
        return indices = value;
    }
}