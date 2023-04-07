package spoopy.rendering.command;

import lime.math.Matrix4;

class SpoopyRenderCommand {
    public var globalOrder(get, never):Float;
    public var depth(get, never):Float;
    public var type(get, never):SpoopyCommandType;
    public var mat4(get, never):Matrix4;

    public var transparent(get, set):Bool;
    public var skipBatching(get, set):Bool;
    public var is3D(get, set):Bool;

    @:noCompletion private var __globalOrder:Float = 0;
    @:noCompletion private var __depth:Float = 0;
    @:noCompletion private var __type:SpoopyCommandType = SpoopyCommandType.UNKNOWN_COMMAND;
    @:noCompletion private var __transparent:Bool = true;
    @:noCompletion private var __skipBatching:Bool = false;
    @:noCompletion private var __is3D:Bool = false;
    @:noCompletion private var __mat4:Matrix4;

    private function new() {
        /* Empty */
    }
    
    /*
    * Setters.
    */

    @:noCompletion private function set_transparent(value:Bool):Bool {
        return __transparent = value;
    }

    @:noCompletion private function set_skipBatching(value:Bool):Bool {
        return __skipBatching = value;
    }

    @:noCompletion private function set_is3D(value:Bool):Bool {
        return __is3D = value;
    }


    /*
    * Getters.
    */

    @:noCompletion private function get_globalOrder():Float {
        return __globalOrder;
    }

    @:noCompletion private function get_depth():Float {
        return __depth;
    }

    @:noCompletion private function get_type():SpoopyCommandType {
        return __type;
    }

    @:noCompletion private function get_transparent():Bool {
        return __transparent;
    }

    @:noCompletion private function get_skipBatching():Bool {
        return __skipBatching;
    }

    @:noCompletion private function get_is3D():Bool {
        return __is3D;
    }

    @:noCompletion private function get_mat4():Matrix4 {
        return __mat4;
    }
}