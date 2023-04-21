package spoopy.graphics.texture.sampler;

class SpoopySamplerInfo {
    public var magFilter:SpoopySamplerFilter;
    public var minFilter:SpoopySamplerFilter;
    public var sAddressMode:SpoopySamplerAddressMode;
    public var tAddressMode:SpoopySamplerAddressMode;

    public function new(
    ?magFilter:SpoopySamplerFilter = SpoopySamplerFilter.LINEAR,
    ?minFilter:SpoopySamplerFilter = SpoopySamplerFilter.LINEAR,
    ?sAddressMode:SpoopySamplerAddressMode = SpoopySamplerAddressMode.CLAMP_TO_EDGE,
    ?tAddressMode:SpoopySamplerAddressMode = SpoopySamplerAddressMode.CLAMP_TO_EDGE) {
        this.magFilter = magFilter;
        this.minFilter = minFilter;
        this.sAddressMode = sAddressMode;
        this.tAddressMode = tAddressMode;
    }
}