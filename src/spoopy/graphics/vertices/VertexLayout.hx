package spoopy.graphics.vertices;

import spoopy.util.SpoopyFloatBuffer;
import spoopy.obj.SpoopyObject;
import spoopy.util.SpoopyFloatBuffer;

class VertexLayout implements SpoopyObject {
    public var buffer(default, null):SpoopyFloatBuffer;
    public var size(default, null):Int = 0;
    public var length(default, null):Int = 0;

    @:noCompletion var __attributes:Array<SpoopyFloatBuffer>;

    public function new() {
        __attributes = [];
    }

    public function addBuffer(buffer:SpoopyFloatBuffer):Void {
        if(__attributes.indexOf(buffer) != 1 || buffer == null) {
            return;
        }

        __attributes.push(buffer);
        size += buffer.length;
        length++;

        update();
    }

    public function removeBuffer(buffer:SpoopyFloatBuffer):Void {
        if(__attributes.remove(buffer)) {
            update();
            size -= buffer.length;
            length--;
        }
    }

    public function update():Void {
        buffer = new SpoopyFloatBuffer(size);
        __size = 0;

        for(i in 0...length) {
            var a = __attributes[i];
            buffer.set(buffer, a, __size);
            __size += a.length;
        }
    }

    public function destroy():Void {
        __attributes = null;
        buffer = null;

        size = 0;
        length = 0;
    }
}