package spoopy.graphics.state;

class SpoopyStateManager {
    public var currentState(get, never):SpoopyState;

    @:noCompletion private var __queueState:SpoopyState;
    @:noCompletion private var __currentState:SpoopyState;
    @:noCompletion private var __initialState:Class<SpoopyState>;

    /* TODO: Make SpoopyStateManager handle other modules too like: */
    // @:noCompletion private var __inputModule:SpoopyInputModule;
    // @:noCompletion private var __soundModule:SpoopySoundModule;

    /* TODO: Also have these modules to be parameters in the constructor. */
    public function new(?__initialState:Class<SpoopyState>) {
        this.__initialState = (__initialState == null) ? SpoopyState : __initialState;
    }

    public function resetState():Void {
        __queueState = Type.createInstance(__initialState, []);
    }

    public function switchState(next:SpoopyState):Void {
        /* TODO: The SpoopyStateManager should be able to flush the modules when switching states. */

        next.addManager(this);
    }

    public function transitionedOut():Bool {
        return true;
    }

    @:noCompletion private function get_currentState():SpoopyState {
        /*
        * TODO: Output a warning if the __currentState is null.
        * But first, I need a good frontend logger.
        */

        return __currentState;
    }
}