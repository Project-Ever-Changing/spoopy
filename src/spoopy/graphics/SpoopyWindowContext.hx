package spoopy.graphics;

import spoopy.graphics.renderer.SpoopyRenderPass;
import spoopy.graphics.renderer.SpoopyRenderPass;
import spoopy.graphics.commands.SpoopyCommandManager;
import spoopy.graphics.state.SpoopyStateManager;
import spoopy.graphics.SpoopyAccessFlagBits;
import spoopy.graphics.SpoopyPipelineStageFlagBits;
import spoopy.window.IWindowHolder;

import lime.math.Rectangle;
import lime.math.Matrix3;
import lime.math.Vector2;
import lime.ui.Window;

/*
* TODO: This class is a mess. It's a mess because I'm not sure how to handle DPI scaling.
* I also have yet to implement viewport and scissor scaling, so this class is pretty much useless.
*/

@:access(lime.ui.Window)
@:access(spoopy.graphics.renderer.SpoopyRenderPass)
@:access(spoopy.graphics.state.SpoopyStateManager)
class SpoopyWindowContext implements IWindowHolder {
    public var module(get, never):SpoopyGraphicsModule;
    public var window(get, never):Window;

    public var displayWidth(default, null):Int = 0;
    public var displayHeight(default, null):Int = 0;

    @:noCompletion private var __window:Window;
    @:noCompletion private var __renderPass:SpoopyRenderPass;
    @:noCompletion private var __stateManager:SpoopyStateManager;
    @:noCompletion private var __module:SpoopyGraphicsModule;
    @:noCompletion private var __displayMatrix:Matrix3;
    @:noCompletion private var __viewportRect:Rectangle;
    @:noCompletion private var __active:Bool;
    @:noCompletion private var __rtCount:Int;
    @:noCompletion private var __rtDirty:Bool;

    public function new(module:SpoopyGraphicsModule, window:Window, ?stateManager:SpoopyStateManager) {
        __active = false;
        __rtDirty = false;
        __rtCount = 0;

        __window = window;
        __module = module;
        
        __displayMatrix = new Matrix3();
        __viewportRect = new Rectangle();

        __stateManager = stateManager != null ? stateManager : new SpoopyStateManager();
        __stateManager.bindToContext(this);
    }

    public function onFlush():Void {
        __active = false;

        /*
        __stateManager.flush();
        __stateManager = null;

        __renderPass.destroy();
        __renderPass = null;
        */
    }

    public function onDraw():Void {
        // TODO: Implement the pipeline manager and check if the pipeline is good to go

        var cmdBuffer = __stateManager.__commandManager.getCmdBuffer();
        // TODO: Get the pipeline Layout and check if it's good to go

        if(__rtDirty && cmdBuffer.state == INSIDE_RENDER_PASS) {
            endRenderPass();
        }

        __stateManager.draw();
    }

    public function resize():Void {
        var windowWidth = Std.int(__window.width * __window.scale);
		var windowHeight = Std.int(__window.height * __window.scale);

        __setViewport(windowWidth, windowHeight);
    }

    public function resetRenderTarget():Void {
        if(__rtCount != 0) {
            __rtDirty = true;
            __rtCount = 0;
        }

        // TODO: Call destroy `__depthView` which if the wrapper has a CFFIPointer, then delete it.
        // `__depthView` should be a Depth Image View for Haxe, this would allow for frontend flexibility.

        var cmdBuffer = __stateManager.__commandManager.getCmdBuffer();

        if(cmdBuffer.state == INSIDE_RENDER_PASS) {
            endRenderPass();
        }
    }

    public function endRenderPass():Void {
        __stateManager.endRenderPass();

        __renderPass.destroy();
        __renderPass = null;

        // TODO STATE: Handle pipeline barrier
    }

    public function flushState():Void {
        var cmdBuffer = __stateManager.__commandManager.getCmdBuffer();

        if(cmdBuffer.state == INSIDE_RENDER_PASS) {
            endRenderPass();
        }

        // TODO STATE: Handle render pass and pipeline barrier
        __stateManager.flush();
    }

    @:noCompletion private function createRenderPass():Void {
        if(__renderPass != null) {
            return;
        }

        //var attributes = __window.__attributes.context;
    }

    @:noCompletion private function __setViewport(width:Int, height:Int):Void {
        displayWidth = width;
        displayHeight = height;

        #if !spoopy_dpi_aware
        displayWidth = Math.round(displayWidth / __window.scale);
        displayHeight = Math.round(displayHeight / __window.scale);

        __displayMatrix.identity();
        __displayMatrix.scale(__window.scale, __window.scale);
        #end

        __viewportRect.setTo(
            __displayMatrix.tx,
            __displayMatrix.ty,
            displayWidth * __displayMatrix.a + __displayMatrix.tx, // Matrix transformation X
            displayHeight * __displayMatrix.d + __displayMatrix.ty // Matrix transformation Y
        );
    }

    @:noCompletion private function get_window():Window {
        return __window;
    }

    @:noCompletion private function get_module():SpoopyGraphicsModule {
        return __module;
    }
}