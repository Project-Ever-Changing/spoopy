package spoopy.utils;

import lime.utils.Log;

class SpoopyLogger {
    public static inline function info(msg:Dynamic):Void {
        var smsg = "\033[0m" + Std.string(msg);

        #if js
        untyped #if haxe4 js.Syntax.code #else __js__ #end (typeOfOutput("[INFO]") + smsg);
        #else
        Log.println(typeOfOutput("[INFO]") + smsg);
        #end
    }

    public static inline function warn(msg:Dynamic):Void {
        var smsg = "\033[1m\033[33m" + Std.string(msg) + "\033[0m";

        #if js
        untyped #if haxe4 js.Syntax.code #else __js__ #end (typeOfOutput("[WARN]") + smsg);
        #else
        Log.println(typeOfOutput("[WARN]") + smsg);
        #end
    }

    public static inline function error(msg:Dynamic):Void {
        var smsg = "\033[1m\033[31m" + Std.string(msg) + "\033[0m";

        #if js
        untyped #if haxe4 js.Syntax.code #else __js__ #end (typeOfOutput("[ERROR]") + smsg);
        #else
        Log.println(typeOfOutput("[ERROR]") + smsg);
        #end
    }

    public static inline function success(msg:Dynamic):Void {
        var smsg = "\033[1m\033[32m" + Std.string(msg) + "\033[0m";

        #if js
        untyped #if haxe4 js.Syntax.code #else __js__ #end (typeOfOutput("[ERROR]") + smsg);
        #else
        Log.println(typeOfOutput("[ERROR]") + smsg);
        #end
    }

    private static inline function typeOfOutput(first:String):String {
        return "\033[1m\033[37m" + first + " " + "\033[0m";
    }
}