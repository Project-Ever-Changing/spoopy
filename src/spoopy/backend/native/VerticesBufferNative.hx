package spoopy.backend.native;

#if (spoopy_vulkan || spoopy_metal)
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

    }
    #end
}