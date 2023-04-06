package spoopy.frontend.storage;

import spoopy.graphics.other.SpoopySwapChain;
import spoopy.graphics.SpoopyBuffer;

import lime.utils.Log;

class SpoopyBufferStorage {

    /*
    * `lists` is an array of SpoopyBuffers.
    */
    public var list(default, null):Array<SpoopyBuffer>;

    /*
    * `parent` is the parent scene.
    */
    public var parent(default, null):SpoopySwapChain;

    @:allow(spoopy.graphics.other.SpoopySwapChain) private function new(parent:SpoopySwapChain) {
        list = new Array<SpoopyBuffer>();

        this.parent = parent;
    }

    /*
    * `addBuffer` adds a buffer to the list.
    * @param buffer is the buffer to add.
    */
    public function addBuffer(buffer:SpoopyBuffer):SpoopyBuffer {
        #if (haxe >= "4.0.0")
        if(list.contains(buffer)) return buffer;
        #else
        if(list.indexOf(buffer) != -1) return buffer;
        #end

        list.push(buffer);
        return buffer;
    }

    /*
    * `removeBuffer` removes a buffer from the list.
    * @param buffer is the buffer to remove.
    * @param destroy is whether or not to destroy the buffer.
    */
    public function removeBuffer(buffer:SpoopyBuffer, destroy:Bool = true) {
        var index:Int = list.indexOf(buffer);

        if(buffer != null && index != -1) {
            list.splice(index, 1);
        }else {
            Log.warn("`SpoopyBuffer` not found in buffer list");
            return;
        }

        if(destroy) {
            buffer.destroy();
        }
    }

    /*
    * `beginFrame` is called at the beginning of each frame.
    */
    public function beginFrame():Void {
        var index = 0;
        
        while(index < list.length) {
            var buffer = list[index++];
            buffer.beginFrame();
        }
    }

    public function destroy():Void {
        var index = 0;
        
        while(index < list.length) {
            var buffer = list[index++];
            buffer.destroy();
            buffer = null;
        }
    }
}