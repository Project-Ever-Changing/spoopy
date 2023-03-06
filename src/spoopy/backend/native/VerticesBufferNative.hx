package spoopy.backend.native;

#if (spoopy_vulkan || spoopy_metal)
import spoopy.graphics.other.SpoopySwapChain;

@:access(spoopy.graphics.other.SpoopySwapChain)
#end
@:access(spoopy.graphics.SpoopyBuffer)
class VerticesBufferNative {
    public function new() {
        /*
        * Empty.
        */
    }

    #if (spoopy_vulkan || spoopy_metal)
    public function setVertexBuffer(device:SpoopySwapChain, buffer:SpoopyBuffer, offset:Int, atIndex:Int):Void {
        SpoopyNativeCFFI.spoopy_set_vertex_buffer(device.__surface.handle, buffer.__backend.handle, offset, atIndex);
    }
    #end
}