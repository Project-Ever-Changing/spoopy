package spoopy.graphics;

import spoopy.backend.native.SpoopyNativeCFFI;
import spoopy.graphics.renderer.SpoopyRenderPass;

import lime.app.IModule;
import lime.app.Application;
import lime.ui.Window;
import lime.graphics.RenderContextAttributes;

@:access(lime.ui.Window)
class SpoopyGraphicsModule implements IModule {
    @:noCompletion private var __application:Application;
    @:noCompletion private var __backend:BackendGraphicsModule;
    @:noCompletion private var __createFirstWindow:Bool = false;

    public function new() {
        __backend = new BackendGraphicsModule();
    }

    @:noCompletion private function __createRenderPass(attributes:RenderContextAttributes):Void {
        var renderPass = new SpoopyRenderPass();
        renderPass.__hasImageLayout = true;
        renderPass.addColorAttachment(SpoopyRenderPass.getFormatFromColorDepth(attributes.colorDepth));

        // Subpass dependency for color attachment
        renderPass.addSubpassDependency(true, false, COLOR_ATTACHMENT_OUTPUT_BIT, COLOR_ATTACHMENT_OUTPUT_BIT,
            MEMORY_READ_BIT, COLOR_ATTACHMENT_READ_BIT | COLOR_ATTACHMENT_WRITE_BIT, 0);

        if(attributes.hardware) {
            if(attributes.depth) {
                var format:SpoopyFormat = attributes.stencil ? SpoopyFormat.D32_SFLOAT_S8_UINT : SpoopyFormat.D32_SFLOAT;
                renderPass.addDepthAttachment(format, attributes.stencil);

                renderPass.addSubpassDependency(true, false, LATE_FRAGMENT_TESTS_BIT, LATE_FRAGMENT_TESTS_BIT,
                    MEMORY_READ_BIT, DEPTH_STENCIL_ATTACHMENT_READ_BIT | DEPTH_STENCIL_ATTACHMENT_WRITE_BIT, 0);
            }
        }

        renderPass.processAttachments();
        renderPass.createSubpass();
        renderPass.createRenderPass();
    }

    @:noCompletion private function __onCreateWindow(window:Window):Void {
        if(!__createFirstWindow) {
            __application.onUpdate.add(__onUpdate);
            __application.onExit.add(__onModuleExit, false, 0);

            #if spoopy_debug
            __backend.check();
            #end

            __createFirstWindow = true;
        }

        __createRenderPass(window.__attributes.context);
    }

    @:noCompletion private function __onUpdate(deltaTime:Int):Void {
        __backend.update();

        // TODO: Add an event system that will have graphic wise events.
    }

    @:noCompletion private function __onModuleExit(code:Int):Void {
        // TODO: Dispatch anything in the future.
    }

    @:noCompletion private function __registerLimeModule(application:Application):Void {
        __application = application;

        application.onCreateWindow.add(__onCreateWindow);
    }

    @:noCompletion private function __unregisterLimeModule(application:Application):Void {
        __application = null;

        application.onCreateWindow.remove(__onCreateWindow);

        if(__createFirstWindow) {
            application.onUpdate.remove(__onUpdate);
		    application.onExit.remove(__onModuleExit);
        }
    }
}

#if spoopy_vulkan
typedef BackendGraphicsModule = spoopy.backend.native.SpoopyNativeGraphics;
#end