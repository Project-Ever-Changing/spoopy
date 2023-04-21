#include <graphics/Sampler.h>

namespace lime {
    static int id_magFilter;
    static int id_minFilter;
    static int id_sAddressMode;
    static int id_tAddressMode;
    static bool init = false;

    SamplerDescriptor::SamplerDescriptor(value descriptor) {
        if (!init) {
            id_magFilter = val_id("magFilter");
            id_minFilter = val_id("minFilter");
            id_sAddressMode = val_id("sAddressMode");
            id_tAddressMode = val_id("tAddressMode");
            init = true;
        }

        magFilter = (SamplerFilter)val_number(val_field(descriptor, id_magFilter));
        minFilter = (SamplerFilter)val_number(val_field(descriptor, id_minFilter));
        sAddressMode = (SamplerAddressMode)val_number(val_field(descriptor, id_sAddressMode));
        tAddressMode = (SamplerAddressMode)val_number(val_field(descriptor, id_tAddressMode));
    }
}