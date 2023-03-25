package spoopy.backend.macro;

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
        checkVersions();
        checkGraphicsAPI();
    }

    static function checkGraphicsAPI():Void {
        var checkForGrahicsAPI:Bool = false;
        var throwError = false;

        for(api in Type.allEnums(SpoopyAPISupport)) {
            var defineAPI = Std.string(api).toLowerCase();
            replaceChar(replaceChar, "_", "-");

            if(defined(api)) {
                if(defined("spoopy-find-api-debug")) {
                    Context.info("Found: " + Std.string(api), (macro null).pos);
                }

                if(checkForGrahicsAPI) {
                    throwError = true;
                    break;
                }

                checkForGrahicsAPI = true;
            }
        }

        if(!checkForGrahicsAPI) {
            throwError = true;

            if(defined("spoopy-find-api-debug")) { {
                Context.info("Found no graphic APIs.");
            }
        }

        if(throwError) {
            abort("Graphics API not specified. Please specify a graphics API to use for rendering. Only one graphics API can be used at a time.", (macro null).pos);
        }
    }

    static function checkVersions():Void {
        #if (lime < "7.7.0")
        Context.warning('Lime version may not be compatible with Spoopy Engine (expected version 6.3.0)', (macro null).pos);
        #end
    }

    static inline function replaceChar(str:String, oldChar:String, newChar:String):String {
        return str.split(oldChar).join(newChar);
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