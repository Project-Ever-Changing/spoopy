package spoopy.graphics;

/*
* https://registry.khronos.org/vulkan/specs/1.3-extensions/man/html/VkAccessFlagBits.html
*/

#if (haxe_ver >= 4.0) enum #else @:enum #end abstract SpoopyAccessFlagBits(Int) from Int to Int from UInt to UInt {
    public var INDIRECT_COMMAND_READ_BIT:Int = 0x00000001;
    public var INDEX_READ_BIT:Int = 0x00000002;
    public var VERTEX_ATTRIBUTE_READ_BIT:Int = 0x00000004;
    public var UNIFORM_READ_BIT:Int = 0x00000008;
    public var INPUT_ATTACHMENT_READ_BIT:Int = 0x00000010;
    public var SHADER_READ_BIT:Int = 0x00000020;
    public var SHADER_WRITE_BIT:Int = 0x00000040;
    public var COLOR_ATTACHMENT_READ_BIT:Int = 0x00000080;
    public var COLOR_ATTACHMENT_WRITE_BIT:Int = 0x00000100;
    public var DEPTH_STENCIL_ATTACHMENT_READ_BIT:Int = 0x00000200;
    public var DEPTH_STENCIL_ATTACHMENT_WRITE_BIT:Int = 0x00000400;
    public var TRANSFER_READ_BIT:Int = 0x00000800;
    public var TRANSFER_WRITE_BIT:Int = 0x00001000;
    public var HOST_READ_BIT:Int = 0x00002000;
    public var HOST_WRITE_BIT:Int = 0x00004000;
    public var MEMORY_READ_BIT:Int = 0x00008000;
    public var MEMORY_WRITE_BIT:Int = 0x00010000;
    public var TRANSFORM_FEEDBACK_WRITE_BIT_EXT:Int = 0x02000000;
    public var TRANSFORM_FEEDBACK_COUNTER_READ_BIT_EXT:Int = 0x04000000;
    public var TRANSFORM_FEEDBACK_COUNTER_WRITE_BIT_EXT:Int = 0x08000000;
    public var CONDITIONAL_RENDERING_READ_BIT_EXT:Int = 0x00100000;
    public var COLOR_ATTACHMENT_READ_NONCOHERENT_BIT_EXT:Int = 0x00080000;
    public var ACCELERATION_STRUCTURE_READ_BIT_KHR:Int = 0x00200000;
    public var ACCELERATION_STRUCTURE_WRITE_BIT_KHR:Int = 0x00400000;
    public var FRAGMENT_DENSITY_MAP_READ_BIT_EXT:Int = 0x01000000;
    public var FRAGMENT_SHADING_RATE_ATTACHMENT_READ_BIT_KHR:Int = 0x00800000;
    public var COMMAND_PREPROCESS_READ_BIT_NV:Int = 0x00020000;
    public var COMMAND_PREPROCESS_WRITE_BIT_NV:Int = 0x00040000;
}