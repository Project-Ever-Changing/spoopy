package spoopy.graphics.state;

import spoopy.utils.SpoopyDestroyable;

@:allow(spoopy.graphics.state.SpoopyStateManager)
class SpoopyState implements ISpoopyDestroyable {
    public var manager(default, null):SpoopyStateManager;

    public function new() {

    }

    public function destroy():Void {
        manager = null;
    }

    private inline function addManager(manager:SpoopyStateManager):Void {
        this.manager = manager;
    }
}