package spoopy.graphics.descriptor;

/*
* This is a skeleton class right now, but it will be used to manage the descriptors in general.
*/
class SpoopyDescriptorManager {
    public function new() {}

    public function acquirePoolContainer():SpoopyDescriptorPoolContainer {
        return null;
    }

    public function releasePoolContainer(poolSetContainer:SpoopyDescriptorPoolContainer):Void {
        return;
    }
}