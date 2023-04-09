package spoopy.rendering.command;

import spoopy.graphics.SpoopyBuffer;
import spoopy.obj.SpoopyCamera;

class SpoopyCommand extends SpoopyRenderCommand {
    public var beforeCallback:Void->Void;
    public var afterCallback:Void->Void;

    public var vertexDrawStart(get, never):Int;
    public var vertexDrawCount(get, never):Int;

    public var indexDrawOffset(get, never):Int;
    public var indexDrawCount(get, never):Int;

    public var lineWidth(get, set):Float;

    public var vertexCapacity(get, never):Int;
    public var indexCapacity(get, never):Int;

    public var vertexBuffer(default, null):SpoopyBuffer;
    public var indexBuffer(default, null):SpoopyBuffer;

    @:noCompletion private var __vertexDrawStart:Int = 0;
    @:noCompletion private var __vertexDrawCount:Int = 0;

    @:noCompletion private var __indexDrawOffset:Int = 0;
    @:noCompletion private var __indexDrawCount:Int = 0;

    @:noCompletion private var __indexSize:Int = 0;
    @:noCompletion private var __lineWidth:Float = 0;

    @:noCompletion private var __vertexCapacity:Int = 0;
    @:noCompletion private var __indexCapacity:Int = 0;

    public function new(vcam:SpoopyCamera) {
        super(vcam);
    }

    public inline function setVertexDrawInfo(start:Int, count:Int):Void {
        __vertexDrawStart = start;
        __vertexDrawCount = count;
    }

    public inline function setIndexDrawInfo(start:Int, count:Int):Void {
        __indexDrawOffset = start * __indexSize;
        __indexDrawCount = count;
    }

    public function setVertexBuffer(vertexBuffer:SpoopyBuffer):Void {
        if(this.vertexBuffer != vertexBuffer && this.vertexBuffer != null) {
            this.vertexBuffer.destroy();
        }

        this.vertexBuffer = vertexBuffer;
    }

    public function setIndexBuffer(indexBuffer:SpoopyBuffer, indexFormat:Int):Void {
        if(this.indexBuffer != indexBuffer && this.indexBuffer != null) {
            this.indexBuffer.destroy();
        }

        this.indexBuffer = indexBuffer;
    }

    public override function destroy():Void {
        super.destroy();

        vertexBuffer = null;
        indexBuffer = null;
    }

    /*
    * Setters.
    */

    @:noCompletion function set_lineWidth(value:Float):Float {
        return __lineWidth = value;
    }

    
    /*
    * Getters.
    */

    @:noCompletion function get_vertexDrawStart():Int {
        return __vertexDrawStart;
    }

    @:noCompletion function get_vertexDrawCount():Int {
        return __vertexDrawCount;
    }

    @:noCompletion function get_indexDrawOffset():Int {
        return __indexDrawOffset;
    }

    @:noCompletion function get_indexDrawCount():Int {
        return __indexDrawCount;
    }

    @:noCompletion function get_lineWidth():Float {
        return __lineWidth;
    }

    @:noCompletion function get_vertexCapacity():Int {
        return __vertexCapacity;
    }
    
    @:noCompletion function get_indexCapacity():Int {
        return __indexCapacity;
    }
}