package spoopy.obj.prim;

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
    */
    private var vertices(default, set):SpoopyFloatBuffer;

    /*
    * The `indices` of the vertices that form the primitive.
    */
    private var indices(default, set):SpoopyFloatBuffer;

    public function new() {
        /*
        * Empty.
        */
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
    
    public function clear():Void {
        inScene = false;
    }

    public function toString() {
		return Type.getClassName(Type.getClass(this)).split(".").pop();
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

    @:noCompletion function set_vertices(value:SpoopyFloatBuffer):SpoopyFloatBuffer {
        return vertices = value;
    }

    @:noCompletion function set_indices(value:SpoopyFloatBuffer):SpoopyFloatBuffer {
        return indices = value;
    }
}