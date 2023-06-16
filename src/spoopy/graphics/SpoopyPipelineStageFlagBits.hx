package spoopy.graphics;

/*
* https://registry.khronos.org/vulkan/specs/1.3-extensions/man/html/VkPipelineStageFlagBits.html
*/

#if (haxe_ver >= 4.0) enum #else @:enum #end abstract SpoopyPipelineStageFlagBits(Int) from Int to Int from UInt to UInt {
    public var TOP_OF_PIPE_BIT:Int = 0x00000001;
    public var DRAW_INDIRECT_BIT:Int = 0x00000002;
    public var VERTEX_INPUT_BIT:Int = 0x00000004;
    public var VERTEX_SHADER_BIT:Int = 0x00000008;
    public var TESSELLATION_CONTROL_SHADER_BIT:Int = 0x00000010;
    public var TESSELLATION_EVALUATION_SHADER_BIT:Int = 0x00000020;
    public var GEOMETRY_SHADER_BIT:Int = 0x00000040;
    public var FRAGMENT_SHADER_BIT:Int = 0x00000080;
    public var EARLY_FRAGMENT_TESTS_BIT:Int = 0x00000100;
    public var LATE_FRAGMENT_TESTS_BIT:Int = 0x00000200;
    public var COLOR_ATTACHMENT_OUTPUT_BIT:Int = 0x00000400;
    public var COMPUTE_SHADER_BIT:Int = 0x00000800;
    public var TRANSFER_BIT:Int = 0x00001000;
    public var BOTTOM_OF_PIPE_BIT:Int = 0x00002000;
    public var HOST_BIT:Int = 0x00004000;
    public var ALL_GRAPHICS_BIT:Int = 0x00008000;
    public var ALL_COMMANDS_BIT:Int = 0x00010000;
    public var NONE = 0;
    public var TRANSFORM_FEEDBACK_BIT_EXT:Int = 0x01000000;
    public var CONDITIONAL_RENDERING_BIT_EXT:Int = 0x00040000;
    public var ACCELERATION_STRUCTURE_BUILD_BIT_KHR:Int = 0x02000000;
    public var RAY_TRACING_SHADER_BIT_KHR:Int = 0x00200000;
    public var FRAGMENT_DENSITY_PROCESS_BIT_EXT:Int = 0x00800000;
    public var FRAGMENT_SHADING_RATE_ATTACHMENT_BIT_KHR:Int = 0x00400000;
    public var COMMAND_PREPROCESS_BIT_NV:Int = 0x00020000;
    public var TASK_SHADER_BIT_EXT:Int = 0x00080000;
    public var MESH_SHADER_BIT_EXT:Int = 0x00100000;
}