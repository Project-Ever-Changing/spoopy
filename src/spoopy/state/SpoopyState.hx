package spoopy.state;

import spoopy.graphics.SpoopyScene;
import spoopy.obj.prim.SpoopyPrimitiveGroup;
import spoopy.obj.prim.SpoopyPrimitive;

class SpoopyState extends SpoopyPrimitiveGroup<SpoopyPrimitive> {
    @:allow(spoopy.graphics.SpoopyScene) public var device:SpoopyScene;

    public function new() {
        super();
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