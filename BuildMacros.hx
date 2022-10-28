package spoopy.macros;

import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr.Position;

using StringTools;

private enum GraphicsAPI_Enum {
    USING_VULKAN;
    USING_WEBGL; //Maybe in the future...
}

class BuildMacro {
    public static function build():Void {
        if(Context.defined("web")) {
            defineEnum(USING_WEBGL);
        }else {
            defineEnum(USING_VULKAN);
        }
    }

    static inline function defineEnum(define:Dynamic):Void {
        Compiler.define(Std.string(define));
    }
}