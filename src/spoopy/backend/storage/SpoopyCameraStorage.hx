package spoopy.backend.storage;

import spoopy.obj.SpoopyCamera;

class SpoopyCameraStorage {
    public var list(default, null):Array<SpoopyCamera>;

    @:allow(spoopy.graphics.SpoopyScene) private function new() {
        list = new Array<SpoopyCamera>();
    }
}