package spoopy.graphics.state;

import spoopy.graphics.commands.SpoopyCommandManager;
import spoopy.graphics.SpoopyGraphicsModule;
import spoopy.graphics.SpoopyWindowContext;
import spoopy.utils.SpoopyLogger;

class SpoopyStateManager {
    public var context(get, never):SpoopyWindowContext;
    public var currentState(get, never):SpoopyState;

    @:noCompletion private var __queueState:SpoopyState;
    @:noCompletion private var __currentState:SpoopyState;
    @:noCompletion private var __initialState:Class<SpoopyState>;
    @:noCompletion private var __commandManager:SpoopyCommandManager<SpoopyWindowContext>;
    @:noCompletion private var __context:SpoopyWindowContext;

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
        if(__currentState == next || __queueState == next) {
            return;
        }

        __queueState = next;
    }

    public function update():Void {
        if(__queueState != null) {
            processSwitchState();
        }
    }

    @:allow(spoopy.graphics.SpoopyWindowContext)
    private inline function bindToContext(context:SpoopyWindowContext):Void {
        __commandManager = new SpoopyCommandManager<SpoopyWindowContext>(context);
        __context = context;
    }

    private function processSwitchState():Void {
        if(__queueState == __currentState) {
            __queueState = null;
            return;
        }

        // Make sure to destroy the current state.
        if(__currentState != null) {
            __currentState.destroy();
        }

        __currentState = __queueState;
        __currentState.bind(this);
        __currentState.create();

        __queueState = null;
    }

    @:noCompletion private function get_currentState():SpoopyState {
        if(__currentState == null) {
            SpoopyLogger.warn("Current state is null! Try calling `switchState` first.");
        }

        return __currentState;
    }

    @:noCompletion private function get_context():SpoopyWindowContext {
        if(__context == null) {
            SpoopyLogger.error("SpoopyStateManager is required to have a context!");
        }

        return __context;
    }
}