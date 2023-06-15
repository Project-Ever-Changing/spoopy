package spoopy.graphics;

import spoopy.backend.native.SpoopyNativeCFFI;
import spoopy.graphics.renderer.SpoopyRenderPass;

import lime.app.IModule;
import lime.app.Application;
import lime.ui.Window;
import lime.graphics.RenderContextAttributes;

@:access(lime.ui.Window)
class SpoopyGraphicsModule implements IModule {
    @:noCompletion private var __backend:BackendGraphicsModule;

    public function new() {
        __backend = new BackendGraphicsModule();
    }

    @:noCompletion private function __createRenderPass(attributes:RenderContextAttributes):Void {
        var renderPass = new SpoopyRenderPass();
        renderPass.__hasImageLayout = true;
        renderPass.addColorAttachment(SpoopyRenderPass.getFormatFromColorDepth(attributes.colorDepth));

        if(attributes.hardware) {
            return;
        }

        if(attributes.depth) {
            var format:SpoopyFormat = attributes.stencil ? SpoopyFormat.D32_SFLOAT_S8_UINT : SpoopyFormat.D32_SFLOAT;
            renderPass.addDepthAttachment(format, attributes.stencil);
        }
    }

    @:noCompletion private function __onCreateWindow(window:Window):Void {
        __createRenderPass(window.__attributes.context);
    }

    @:noCompletion private function __onUpdate(deltaTime:Int):Void {
        SpoopyNativeCFFI.spoopy_update_graphics_module();

        // TODO: Add an event system that will have inputs/events.
    }

    @:noCompletion private function __onModuleExit(code:Int):Void {
        // TODO: Dispatch anything in the future.
    }

    @:noCompletion private function __registerLimeModule(application:Application):Void {
        application.onCreateWindow.add(__onCreateWindow);
        application.onUpdate.add(__onUpdate);
        application.onExit.add(__onModuleExit, false, 0);
    }

    @:noCompletion private function __unregisterLimeModule(application:Application):Void {
        application.onCreateWindow.remove(__onCreateWindow);
        application.onUpdate.remove(__onUpdate);
		application.onExit.remove(__onModuleExit);
    }
}

#if spoopy_vulkan
typedef BackendGraphicsModule = spoopy.backend.native.SpoopyNativeGraphics;
#end