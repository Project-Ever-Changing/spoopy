package spoopy.backend.native;

import spoopy.graphics.SpoopyTopology;

class SpoopyNativePipeline {
    public var handle:Dynamic;

    public function new() {
        handle = SpoopyNativeCFFI.spoopy_create_pipeline();
    }

    public function setInputAssembly(topology:SpoopyTopology):Void {
        SpoopyNativeCFFI.spoopy_pipeline_set_input_assembly(handle, topology);
    }
}