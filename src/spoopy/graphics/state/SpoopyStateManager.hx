package spoopy.graphics.state;

import spoopy.utils.destroy.SpoopyDestroyable;
import spoopy.graphics.commands.SpoopyCommandManager;
import spoopy.graphics.SpoopyGraphicsModule;
import spoopy.utils.SpoopyLogger;

class SpoopyStateManager implements ISpoopyDestroyable {
    public var module(get, never):SpoopyGraphicsModule;
    public var currentState(get, never):SpoopyState;

    @:noCompletion private var __queueState:SpoopyState;
    @:noCompletion private var __currentState:SpoopyState;
    @:noCompletion private var __initialState:Class<SpoopyState>;
    @:noCompletion private var __module:SpoopyGraphicsModule;

    /*
    * This command manager is suppose to handle offscreen rendering.
    * The manager will give each state their own dedicated offscreen buffer while the manager and the pool hold them.
    * Once the manager is done with the offscreen buffer, it will ship it off to the swapchain for post processing.
    */
    @:noCompletion private var __commandManager:SpoopyCommandManager<SpoopyGraphicsModule>;

    /* TODO: Make SpoopyStateManager handle other modules too like: */
    // @:noCompletion private var __inputModule:SpoopyInputModule;
    // @:noCompletion private var __soundModule:SpoopySoundModule;

    /* TODO: Also have these modules to be parameters in the constructor. */
    public function new(?__initialState:Class<SpoopyState>) {
        this.__initialState = (__initialState == null) ? SpoopyState : __initialState;
    }

    public function destroy():Void {
        // TODO: Work on this

        __commandManager.submitActiveCmdBuffer();
        __commandManager.destroy();
        __commandManager = null;

        if(__queueState != null) {
            __queueState.destroy();
            __queueState = null;
        }

        if(__currentState != null) {
            __currentState.destroy();
            __currentState = null;
        }
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

    @:allow(spoopy.graphics.SpoopyGraphicsModule) private function draw():Void {
        
    }

    @:allow(spoopy.graphics.SpoopyGraphicsModule) private function update():Void {
        if(__queueState != null) {
            processSwitchState();
        }
    }

    private function endRenderPass():Void {
        var cmdBuffer = __commandManager.getCmdBuffer();
        cmdBuffer.endRenderPass();
    }

    @:allow(spoopy.graphics.SpoopyGraphicsModule)
    private inline function bindToModule(module:SpoopyGraphicsModule):Void {
        __commandManager = new SpoopyCommandManager<SpoopyGraphicsModule>(module);
        __module = module;
    }

    private function processSwitchState():Void {
        if(__queueState == __currentState) {
            __queueState = null;
            return;
        }

        // Make sure to destroy the current state.
        if(__currentState != null) {

            // TODO: In the future, it might be best to have a signal semaphore to use as a param.
            __commandManager.submitActiveCmdBuffer();
            __currentState.destroy();
        }

        __currentState = __queueState;
        __currentState.bind(this, __commandManager);
        __currentState.create();

        __queueState = null;
    }

    @:noCompletion private function get_currentState():SpoopyState {
        if(__currentState == null) {
            SpoopyLogger.warn("Current state is null! Try calling `switchState` first.");
        }

        return __currentState;
    }

    @:noCompletion private function get_module():SpoopyGraphicsModule {
        return __module;
    }
}