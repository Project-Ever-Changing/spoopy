package spoopy.backend.native;

import spoopy.app.SpoopyEngine;
import spoopy.graphics.modules.SpoopyFlags;
import spoopy.utils.destroy.SpoopyDestroyable.ISpoopyDestroyable;
import spoopy.graphics.modules.SpoopyGPUObject;
import spoopy.graphics.SpoopyWindowContext;
import spoopy.utils.SpoopyLogger;

@:access(lime.ui.Window)
class SpoopyNativeRenderTask implements ISpoopyDestroyable {
    public var context(default, null):SpoopyWindowContext;
    public var imageCount(default, null):Int;

    @:noCompletion private var __imageAcquiredSemaphores:haxe.ds.Vector<SpoopyGPUObject>;
    @:noCompletion private var __imageFinishedSemaphores:haxe.ds.Vector<SpoopyGPUObject>;
    @:noCompletion private var __imageAcquiredFences:haxe.ds.Vector<SpoopyNativeFence>;
    @:noCompletion private var __acquiredSemaphore:SpoopyGPUObject;
    @:noCompletion private var __currentSemaphoreIndex:Int = 0;
    @:noCompletion private var __acquireImageIndex:Int = 0;

    public function new(context:SpoopyWindowContext) {
        var maxBackBuffers = Math.max(SpoopyEngine.MAX_BACK_BUFFERS * 2, 10);

        this.context = context;

        if(this.context == null) {
            SpoopyLogger.error("SpoopyNativeRenderTask's window context is null!");
        }

        SpoopyNativeEngine.tasks.push(this);
        SpoopyNativeCFFI.spoopy_device_init_swapchain(context.window.__backend.handle, __reCreateSwapchain);
        imageCount = SpoopyNativeCFFI.spoopy_device_get_swapchain_image_count(context.window.__backend.handle);

        __imageAcquiredFences = new haxe.ds.Vector<SpoopyNativeFence>(maxBackBuffers);
        __imageAcquiredSemaphores = new haxe.ds.Vector<SpoopyGPUObject>(maxBackBuffers);
        __imageFinishedSemaphores = new haxe.ds.Vector<SpoopyGPUObject>(maxBackBuffers);

        for(i in 0...maxBackBuffers) {
            __imageAcquiredFences[i] = SpoopyNativeEngine.fenceManager.alloc(true);
            __imageAcquiredSemaphores[i] = new SpoopyGPUObject(SEMAPHORE, context.module);
            __imageFinishedSemaphores[i] = new SpoopyGPUObject(SEMAPHORE, context.module);
        }
    }

    public function createSwapchain(width:Int, height:Int):Void {
        SpoopyNativeCFFI.spoopy_device_set_swapchain_size(context.window.__backend.handle, width, height);
        SpoopyNativeCFFI.spoopy_device_create_swapchain(context.window.__backend.handle);
        imageCount = SpoopyNativeCFFI.spoopy_device_get_swapchain_image_count(context.window.__backend.handle);

        for(i in 0...imageCount) {
            __imageAcquiredFences[i] = SpoopyNativeEngine.fenceManager.alloc(true);
            __imageAcquiredSemaphores[i].create();
        }
    }

    public function destroySwapchain():Void {
        context.module.autoDeleteAll();

        SpoopyNativeCFFI.spoopy_device_destroy_swapchain(context.window.__backend.handle);
        __acquiredSemaphore = null;

        for(i in 0...__imageAcquiredFences.length) {
            SpoopyNativeEngine.fenceManager.releaseFence(__imageAcquiredFences[i]);
        }

        for(i in 0...__imageAcquiredSemaphores.length) {
            __imageAcquiredSemaphores[i].destroy();
        }
    }

    public function present():Void {
        
    }

    public function acquireNextImage():Void {
        var __prevSemaphoreIndex:Int = this.__currentSemaphoreIndex;
        this.__currentSemaphoreIndex = (this.__currentSemaphoreIndex + 1) % this.__imageAcquiredSemaphores.length;

        var result = SpoopyNativeCFFI.spoopy_device_acquire_next_image(
            this.context.window.__backend.handle,
            this.__imageAcquiredSemaphores,
            this.__imageAcquiredFences[__currentSemaphoreIndex],
            __prevSemaphoreIndex,
            this.__currentSemaphoreIndex
        );

        if(result >= 0) {
            this.__acquiredSemaphore = this.__imageAcquiredSemaphores[this.__currentSemaphoreIndex];
        }else {
            this.__currentSemaphoreIndex = __prevSemaphoreIndex;
            return;
        }

        __acquireImageIndex = result;
    }

    public function destroy():Void {
        SpoopyNativeEngine.tasks.remove(this);
    }

    @:noCompletion private function __reCreateSwapchain(width:Int, height:Int):Void {
        destroySwapchain();

        #if spoopy_debug
        SpoopyLogger.info("SpoopyNativeRenderTask: Recreating swapchain with size " + width + "x" + height);
        #end

        createSwapchain(width, height);

        #if spoopy_debug
        SpoopyLogger.info("SpoopyNativeRenderTask: Swapchain recreated!");
        #end
    }

    @:noCompletion private function __tryPresent():Void {
        var attempts = 4;
        var result = SpoopyNativeCFFI.spoopy_device_present_image(context.window.__backend.handle, this.__imageFinishedSemaphores[__acquireImageIndex]);

        while(result < 0 && attempts > 0) {
            if(result == -2) {
                SpoopyLogger.warn("SpoopyNativeRenderTask: Present failed due to LOST_SURFACE, retrying...");
            }

            SpoopyNativeCFFI.spoopy_device_recreate_swapchain(context.window.__backend.handle);
            result = SpoopyNativeCFFI.spoopy_device_present_image(context.window.__backend.handle, this.__imageFinishedSemaphores[__acquireImageIndex]);
            attempts--;
        }
    }
}