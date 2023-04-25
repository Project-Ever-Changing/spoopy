package spoopy.graphics.other;

import lime.ui.Window;
import lime.math.Rectangle;

import spoopy.app.SpoopyApplication;
import spoopy.window.WindowEventManager;
import spoopy.obj.prim.SpoopyPrimitiveType;
import spoopy.frontend.storage.SpoopyBufferStorage;
import spoopy.backend.native.SpoopyNativeShader;
import spoopy.graphics.texture.SpoopyTexture;
import spoopy.graphics.texture.SpoopyTextureDescriptor;
import spoopy.graphics.SpoopyBuffer;
import spoopy.rendering.command.SpoopyCommand;
import spoopy.rendering.SpoopyCullMode;
import spoopy.rendering.SpoopyWinding;
import spoopy.rendering.SpoopyDrawType;

@:access(lime.ui.Window)
@:access(spoopy.graphics.texture.SpoopyTexture)
class SpoopySwapChain extends WindowEventManager {
    #if (haxe >= "4.0.0")
    public final application:SpoopyApplication;
    #else
    @:final public var application:SpoopyApplication;
    #end

    public var scissorRect(default, null):Rectangle;
    public var buffers(default, null):SpoopyBufferStorage;
    public var currentCullFace(default, null):SpoopyCullMode = CULL_MODE_NONE;
    public var currentWinding(default, null):SpoopyWinding = CLOCKWISE;
    public var atIndexVertex(default, null):Int = 0;

    private var renderTargetFlags(default, set):Int = 1;

    /*
    * Textures
    */
    public var colorAttachment(default, null):SpoopyTexture;

    @:noCompletion private var __surface:SpoopyNativeSurface;
    @:noCompletion private var __renderTargetFlags:Int;
    @:noCompletion private var __drawnCounter:Int = 0;

    @:noCompletion private var __updateDescriptorDirty:Bool = true;
    @:noCompletion private var __textureDirty:Bool = false;
    @:noCompletion private var __enabledDirty:Bool = false;

    public function new(application:SpoopyApplication) {
        this.application = application;
        this.buffers = new SpoopyBufferStorage(this);
        
        super();
    }

    public function create():Void {
        /*
        * Empty.
        */
    }

    public function onUpdate():Void {
        /*
        * Empty.
        */
    }

    public function useShaderProgram(shader:SpoopyNativeShader):Void {
        __surface.useProgram(shader);
    }

    public function setViewport(rect:Rectangle):Void {
        if(rect == null) {
            return;
        }

        colorAttachment.width = rect.width;
        colorAttachment.height = rect.height;
        colorAttachment.updateTexture();

        __surface.setViewport(rect);
    }

    public function setScissorRect(rect:Rectangle, enabled:Bool):Void {
        if(rect == null) {
            return;
        }

        if(scissorRect.x == rect.x
        && scissorRect.y == rect.y
        && scissorRect.width == rect.width
        && scissorRect.height == rect.height
        && enabled == __enabledDirty) {
            return;
        }

        scissorRect = rect;
        __enabledDirty = enabled;
        __surface.setScissorRect(rect, enabled);
    }

    public function setCullFace(cull:SpoopyCullMode):Void {
        if(currentCullFace == cull) {
            return;
        }

        currentCullFace = cull;
        __surface.cullFace(cull);
    }

    public function setWinding(winding:SpoopyWinding):Void {
        if(currentWinding == winding) {
            return;
        }
        
        currentWinding = winding;
        __surface.winding(winding);
    }

    public override function onWindowUpdate():Void {
        super.onWindowUpdate();

        atIndexVertex = 0;

        __surface.updateWindow();
        buffers.beginFrame();

        if(__updateDescriptorDirty) {
            #if spoopy_metal
            __surface.updateMetalDescriptor();
            #end

            __updateDescriptorDirty = false;
        }

        beginRenderPass();
        onUpdate();

        __surface.release();

    }

    private function drawBasedOnCommand(command:SpoopyCommand):Void {
        if(command.beforeCallback != null) {
            command.beforeCallback();
        }

        setVertexBuffer(command.vertexBuffer, 0);
        setLineWidth(command.lineWidth);

        if(command.drawType == ELEMENTS) {
            setIndexBuffer(command.indexBuffer);
            drawElements(command.primitiveType, command.indexFormat, command.indexDrawCount, command.indexDrawOffset);
            __drawnCounter += command.indexDrawCount;
        }else {
            drawArray(command.primitiveType, command.vertexDrawStart, command.vertexDrawCount);
            __drawnCounter += command.vertexDrawCount;
        }

        if(command.afterCallback != null) {
            command.afterCallback();
        }
    }

    private function beginRenderPass():Void {
        __surface.beginRenderPass();
    }

    private function setRenderTarget():Void {
        __surface.setRenderTarget(__renderTargetFlags, colorAttachment.__backend, null, null);
    }

    private function setVertexBuffer(buffer:SpoopyBuffer, offset:Int):Void {
        __surface.setVertexBuffer(buffer, offset, atIndexVertex);
        atIndexVertex++;
    }

    private function setIndexBuffer(buffer:SpoopyBuffer):Void {
        __surface.setIndexBuffer(buffer);
    }

    private function drawArray(primitiveType:SpoopyPrimitiveType, start:Int, count:Int):Void {
        __surface.drawArray(primitiveType, start, count);
    }

    private function drawElements(primitiveType:SpoopyPrimitiveType, indexFormat:Int, count:Int, offset:Int):Void {
        __surface.drawElements(primitiveType, indexFormat, count, offset);
    }

    private function setLineWidth(width:Float):Void {
        __surface.setLineWidth(width);
    }

    private function destroy():Void {
        /*
        * Empty.
        */
    }

    @:noCompletion override private function __registerWindowModule(window:Window):Void {
        super.__registerWindowModule(window);
        __surface = new SpoopyNativeSurface(window.__backend, application);

        viewportRect = new Rectangle(0, 0, window.width, window.height);
        scissorRect = new Rectangle(0, 0, window.width, window.height);

        colorAttachment = new SpoopyTexture(viewportRect.width, viewportRect.height, this, SpoopyApplication.SPOOPY_DEFAULT_TEXTURE_DESCRIPTOR);

        __textureDirty = true;

        setRenderTarget();
        create();
    }

    @:noCompletion override private function __unregisterWindowModule(window:Window):Void {
        super.__unregisterWindowModule(window);

        __surface.release();
        __surface = null;

        buffers.destroy();
        buffers = null;

        destroy();

        colorAttachments = null;
    }

    @:noCompletion override private function set_renderTargetFlags(value:Int):Int {
        __renderTargetFlags = value;

        if(!__textureDirty) {
            setRenderTarget();
        }
        
        return renderTargetFlags = value;
    }
}

#if spoopy_vulkan
typedef SpoopyNativeSurface = spoopy.backend.native.vulkan.SpoopyNativeSurface;
#elseif spoopy_metal
typedef SpoopyNativeSurface = spoopy.backend.native.metal.SpoopyNativeSurface;
#end