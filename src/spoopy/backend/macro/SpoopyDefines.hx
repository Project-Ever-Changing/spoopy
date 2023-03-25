package src.spoopy.backend.macro;

import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr.Position;

using StringTools;

private enum SpoopyAPISupport {
    SPOOPY_METAL;
    SPOOPY_VULKAN;
}

class SpoopyDefines {
    public static function run():Void {
        checkGraphicsAPI();
    }

    static function checkGraphicsAPI():Void {
        var checkForGrahicsAPI:Bool = false;

        for(define in Context.getDefines().keys()) {
            if(define == "") {

            }
        }
    }
    
    static inline function defined(define:Dynamic) {
        return Context.defined(Std.string(define));
    }

    static inline function define(define:Dynamic) {
        Compiler.define(Std.string(define));
    }

    static function abort(message:String, pos:Position) {
        Context.fatalError(message, pos);
    }
}