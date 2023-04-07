package spoopy.rendering.command;

@:enum abstract SpoopyCommandType(Int) from Int to Int {
    
    /* Predefined Type */
    var UNKNOWN_COMMAND = 0x00000;

    /* Utilized for quad rendering */
    var QUAD_COMMAND = 0x00001;

    /* Utilized for drawing shapes beyond triangles */
    var CUSTOM_COMMAND = 0x00002;

    /* Ability to arrange commands in a hierarchical tree */
    var GROUP_COMMAND = 0x00004;

    /* Utilized drawing 3D meshes */
    var MESH_COMMAND = 0x00008;

    /* Utilized drawing triangles */
    var TRIANGLE_COMMAND = 0x00016;
}