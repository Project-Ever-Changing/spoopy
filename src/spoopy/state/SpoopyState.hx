package spoopy.state;

import spoopy.graphics.SpoopyScene;
import spoopy.obj.prim.SpoopyPrimitiveGroup;
import spoopy.obj.prim.SpoopyPrimitive;

class SpoopyState extends SpoopyPrimitiveGroup<SpoopyPrimitive> {
    #if (haxe >= "4.0.0")
    public final scene:SpoopyScene;
    #else
    @:final public var scene:SpoopyScene;
    #end

    public function new(scene:SpoopyScene) {
        super();

        this.scene = scene;
    }

    public function create():Void {
        /*
        * Empty.
        */
    }

    public function switchTo(nextState:SpoopyState):Bool {
        return true;
    }
}