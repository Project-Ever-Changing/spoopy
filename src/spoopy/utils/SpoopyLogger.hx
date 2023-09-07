package spoopy.utils;

import lime.utils.Log;

class SpoopyLogger {
    public static inline function info(msg:String):Void {
        msg = "\033[0m" + msg;

        #if js
        untyped #if haxe4 js.Syntax.code #else __js__ #end (typeOfOutput("[INFO]") + msg);
        #else
        Log.println(typeOfOutput("[INFO]") + msg);
        #end
    }

    public static inline function warn(msg:String):Void {
        var msg = "\033[1m\033[33m" + msg + "\033[0m";

        #if js
        untyped #if haxe4 js.Syntax.code #else __js__ #end (msg);
        #else
        Log.println(typeOfOutput("[WARN]") + msg);
        #end
    }

    private static inline function typeOfOutput(first:String):String {
        return "\033[1m\033[37m" + first + " " + "\033[0m";
    }
}