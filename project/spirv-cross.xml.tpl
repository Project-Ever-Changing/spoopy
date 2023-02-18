<xml>
    <files id="spoopy-toolkit-spirv-depends">
        <depend name="lib/spirv-cross/include/spirv_cross/barrier.hpp" />
        <depend name="lib/spirv-cross/include/spirv_cross/external_interface.h" />
        <depend name="lib/spirv-cross/include/spirv_cross/image.hpp" />
        <depend name="lib/spirv-cross/include/spirv_cross/internal_interface.hpp" />
        <depend name="lib/spirv-cross/include/spirv_cross/sampler.hpp" />
        <depend name="lib/spirv-cross/include/spirv_cross/thread_group.hpp" />

        <depend name="lib/spirv-cross/spirv_cfg.hpp" />
        <depend name="lib/spirv-cross/spirv_common.hpp" />
        <depend name="lib/spirv-cross/spirv_cpp.hpp" />
        <depend name="lib/spirv-cross/spirv_cross_c.h" />
        <depend name="lib/spirv-cross/spirv_cross_containers.hpp" />
        <depend name="lib/spirv-cross/spirv_cross_error_handling.hpp" />
        <depend name="lib/spirv-cross/spirv_cross_parsed_ir.hpp" />
        <depend name="lib/spirv-cross/spirv_cross_util.hpp" />
        <depend name="lib/spirv-cross/spirv_cross.hpp" />
        <depend name="lib/spirv-cross/spirv_glsl.hpp" />
        <depend name="lib/spirv-cross/spirv_hlsl.hpp" />
        <depend name="lib/spirv-cross/spirv_msl.hpp" />
        <depend name="lib/spirv-cross/spirv_parser.hpp" />
        <depend name="lib/spirv-cross/spirv_reflect.hpp" />
        <depend name="lib/spirv-cross/spirv.hpp" />
        <depend name="lib/spirv-cross/spirv.h" />
    </files>

    <files id="spoopy-toolkit-spirv" tags="">
        <depend files="spoopy-toolkit-spirv-depends" />

        <file name="lib/spirv-cross/spirv_reflect.cpp" />
        <file name="lib/spirv-cross/spirv_cfg.cpp" />
        <file name="lib/spirv-cross/spirv_cpp.cpp" />
        <file name="lib/spirv-cross/spirv_cross_c.cpp" />
        <file name="lib/spirv-cross/spirv_cross_parsed_ir.cpp" />
        <file name="lib/spirv-cross/spirv_cross_util.cpp" />
        <file name="lib/spirv-cross/spirv_cross.cpp" />
        <file name="lib/spirv-cross/spirv_glsl.cpp" />
        <file name="lib/spirv-cross/spirv_hlsl.cpp" />
        <file name="lib/spirv-cross/spirv_msl.cpp" />
        <file name="lib/spirv-cross/spirv_parser.cpp" />
    </files>
</xml>