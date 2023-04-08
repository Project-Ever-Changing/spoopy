package spoopy.obj;

import spoopy.graphics.SpoopyBufferType;
import spoopy.graphics.manager.TriangleBufferManager;
import spoopy.graphics.vertices.VertexBufferObject;
import spoopy.rendering.command.SpoopyCommand;
import spoopy.rendering.SpoopyDrawType;
import spoopy.obj.display.SpoopyDisplayObject;
import spoopy.obj.prim.SpoopyPrimitive;
import spoopy.util.SpoopyFloatBuffer;

#if (spoopy_vulkan || spoopy_metal)
import spoopy.graphics.other.SpoopySwapChain;
#end

import lime.math.Rectangle;

class SpoopyCamera implements SpoopyDisplayObject {

    /*
    * How many game pixels are displayed horizontally by the camera.
    */
    public var width(default, set):Int;

    /*
    * How many game pixels are displayed vertically by the camera.
    */
    public var height(default, set):Int;

    /*
    * The width of the camera's view in game pixels.
    */
    public var viewWidth(get, never):Float;

    /*
    * The height of the camera's view in game pixels.
    */
    public var viewHeight(get, never):Float;

    /*
    * The visible area of the world that gets cropped off on the left and right when the camera zooms in or out.
    */
    public var viewMarginX(default, null):Float;

    /*
    * The visible area of the world that gets cropped off on the top and bottom when the camera zooms in or out.
    */
    public var viewMarginY(default, null):Float;

    /*
    * The amount of world space that is cropped from the right when the camera zooms in or out.
    */
    public var viewMarginWidth(get, never):Float;
    
    /*
    * The amount of world space that is cropped from the bottom when the camera zooms in or out.
    */
    public var viewMarginHeight(get, never):Float;

    /*
    * The scaling on horizontal axis for this camera.
    */
    public var scaleX(default, null):Float = 0;

    /*
    * The scaling on vertical axis for this camera.
    */
    public var scaleY(default, null):Float = 0;

    /*
    * The default zoom level of the camera, which is utilized for managing its scaling.
    */
    public var initialZoom(default, null):Float = 1;

    /*
    * The current zoom level of the camera.
    */
    public var zoom(default, set):Float = 0;

    /*
    * If `update()` is automatically called;
    */
    public var active(default, set):Bool = true;

    /*
    * If `render()` is automatically called.
    */
    public var visible(default, set):Bool = true;

    /*
    * Whether `update()` and `render()` are automatically called.
    */
    public var inScene(default, set):Bool = true;

    @:noCompletion var __command:SpoopyCommand;

    @:noCompletion var __triangleBuffers:TriangleBufferManager;
    @:noCompletion var __vertices:VertexBufferObject;
    @:noCompletion var __vertexDirty:Bool;

    @:noCompletion var __scissorRect:Rectangle;
    @:noCompletion var __viewportRect:Rectangle;

    #if (spoopy_vulkan || spoopy_metal)
    @:allow(spoopy.frontend.storage.SpoopyCameraStorage) var device(default, set):SpoopySwapChain;
    #end

    public function new(zoom:Float = 0) {
        __triangleBuffers = new TriangleBufferManager();
        __vertices = new VertexBufferObject();
        __command = new SpoopyCommand(this, getCommandType());
        __viewportRect = new Rectangle(0, 0, viewWidth, viewHeight);
        __scissorRect = new Rectangle(0, 0, width, height);

        initialZoom = (zoom < 0) ? 0 : zoom;

    }

    public function setScale(scaleX:Float, scaleY:Float):Void {
        this.scaleX = scaleX;
        this.scaleY = scaleY;

        if(this.scaleX != scaleX) {
            calcMarginX();
        }

        if(this.scaleY != scaleY) {
            calcMarginY();
        }

        updateViewport();
    }

    public function getCommandType():SpoopyCommandType {
        return SpoopyCommandType.UNKNOWN_COMMAND;
    }

    public function getFlags():UInt {
        return 0;
    }

    public function getDepthInView():Float {
        return 0;
    }

    public function beginRenderFrame():Void {
        
    }

    public function render():Void {
        if(__vertexDirty) {
            __vertices.update();
            var verticeBuffer = __vertices.vertices;
            
            __triangleBuffers.createBuffer(verticeBuffer, verticeBuffer.byteLength, VERTEX);
            __vertexDirty = false;
        }
    }

    public function update(elapsed:Float):Void {
        /*
        * Empty.
        */
    }

    @:allow(spoopy.obj.prim.SpoopyPrimitive) function removeBuffer(__vertices:SpoopyFloatBuffer):Void {
        __vertexDirty = true;
        this.__vertices.removeObject(__vertices);
    }

    @:allow(spoopy.obj.prim.SpoopyPrimitive) function storeBuffer(__vertices:SpoopyFloatBuffer):Void {
        __vertexDirty = true;
        this.__vertices.addObject(__vertices);
    }

    public function destroy():Void {
        this.__vertices.destroy();
        this.__vertices = null;
        this.__viewportRect = null;
    }

    public function toString():String {
        return Type.getClassName(Type.getClass(this)).split(".").pop();
    }

    @:noCompletion private function updateViewport():Void {
        __viewportRect.x = viewMarginX;
        __viewportRect.y = viewMarginY;
        __viewportRect.width = viewWidth;
        __viewportRect.height = viewHeight;
    }

    @:noCompletion private function get_viewWidth():Float {
        return width - viewMarginX * 2;
    }

    @:noCompletion private function get_viewHeight():Float {
        return height - viewMarginY * 2;
    }

    @:noCompletion private function get_viewMarginWidth():Float {
        return width - viewMarginX;
    }

    @:noCompletion private function get_viewMarginHeight():Float {
        return height - viewMarginY;
    }

    @:noCompletion private function set_active(value:Bool):Bool {
        return active = value;
    }

    @:noCompletion private function set_visible(value:Bool):Bool {
        return visible = value;
    }

    @:noCompletion private function set_inScene(value:Bool):Bool {
        return inScene = value;
    }

    @:noCompletion private function set_width(value:Int):Int {
        if(width != value && value > 0) {
            width = value;
            __scissorRect.width = value;

            calcMarginX();
            updateViewport();
        }

        return value;
    }

    @:noCompletion private function set_height(value:Int):Int {
        if(height != value && value > 0) {
            height = value;
            __scissorRect.height = value;

            calcMarginY();
            updateViewport();
        }

        return value;
    }

    @:noCompletion private function set_zoom(value:Float):Float {
        setScale(value, value);
        return zoom = value;
    }

    #if (spoopy_vulkan || spoopy_metal)
    @:noCompletion function set_device(value:SpoopySwapChain):SpoopySwapChain {
        __vertices.bindToDevice(value);

        width = value.window.width;
        height = value.window.height;

        return device = value;
    }
    #end

    private inline function calcMarginX():Void {
        viewMarginX = 0.5 * width * (scaleX - initialZoom) / scaleX;
    }

    private inline function calcMarginY():Void {
        viewMarginY = 0.5 * height * (scaleY - initialZoom) / scaleY;
    }
}