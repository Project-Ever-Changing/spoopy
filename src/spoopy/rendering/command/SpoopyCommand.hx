package spoopy.rendering.command;

import spoopy.graphics.SpoopyBuffer;
import spoopy.rendering.command.SpoopyCommandType;
import spoopy.obj.SpoopyCamera;

class SpoopyCommand extends SpoopyRenderCommand {
    public var beforeCallback:Void->Void;
    public var afterCallback:Void->Void;

    public var vertexDrawStart(get, never):Int;
    public var vertexDrawCount(get, never):Int;

    public var indexDrawStart(get, never):Int;
    public var indexDrawCount(get, never):Int;

    public var lineWidth(get, set):Float;

    public var vertexCapacity(get, never):Int;
    public var indexCapacity(get, never):Int;

    @:noCompletion private var __vertexBuffer:SpoopyBuffer;
    @:noCompletion private var __indexBuffer:SpoopyBuffer;

    @:noCompletion private var __vertexDrawStart:Int = 0;
    @:noCompletion private var __vertexDrawCount:Int = 0;

    @:noCompletion private var __indexDrawStart:Int = 0;
    @:noCompletion private var __indexDrawCount:Int = 0;

    @:noCompletion private var __indexSize:Int = 0;
    @:noCompletion private var __lineWidth:Float = 0;

    @:noCompletion private var __vertexCapacity:Int = 0;
    @:noCompletion private var __indexCapacity:Int = 0;

    public function new(vcam:SpoopyCamera, type:SpoopyCommandType) {
        super(vcam);

        __type = type;
    }

    public inline function setVertexDrawInfo(start:Int, count:Int):Void {
        __vertexDrawStart = start;
        __vertexDrawCount = count;
    }

    public inline function setIndexDrawInfo(start:Int, count:Int):Void {
        __indexDrawStart = start * __indexSize;
        __indexDrawCount = count;
    }

    public function setVertexBuffer(vertexBuffer:SpoopyBuffer):Void {
        if(__vertexBuffer != vertexBuffer && __vertexBuffer != null) {
            __vertexBuffer.destroy();
        }

        __vertexBuffer = vertexBuffer;
    }

    public function setIndexBuffer(indexBuffer:SpoopyBuffer):Void {
        if(__indexBuffer != indexBuffer && __indexBuffer != null) {
            __indexBuffer.destroy();
        }

        __indexBuffer = indexBuffer;
    }

    public override function destroy():Void {
        super.destroy();

        __vertexBuffer = null;
        __indexBuffer = null;
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

    @:noCompletion function get_indexDrawStart():Int {
        return __indexDrawStart;
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