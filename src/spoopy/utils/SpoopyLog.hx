package spoopy.utils;

class SpoopyLog {
    public static function info(messsage:Dynamic):Void {
        #if cpp
        untyped __cpp__('printf("%s%s%s", "\033[1m\033[37m", "[Info] ", "\033[0m");');
        untyped __cpp__('printf("%s%s\n", "\033[0m", message);', Std.string(messsage));
        #elseif js
        untyped #if haxe4 js.Syntax.code #else __js__ #end ("console").log('%c[Info] %s', 'color: white; font-weight: bold;', Std.string(messsage));
        #else
        println("[INFO] " + '\033[1m\033[37m[Info] \033[0m' + Std.string(message) + '\033[0m');
        #end
    }

    public static function warn(messsage:Dynamic):Void {
        #if cpp
        untyped __cpp__('printf("%s%s%s", "\033[1m\033[37m", "[WARN] ", "\033[0m");');
        untyped __cpp__('printf("%s%s\n", "\033[1m\033[33m", message);', Std.string(messsage));
        #elseif js
        untyped #if haxe4 js.Syntax.code #else __js__ #end ("console").log('%c[WARN] %s', 'color: yellow; font-weight: bold;', Std.string(messsage));
        #else
        println("[WARN] " + "\033[1m\033[33m" + Std.string(message) + "\033[0m");
        #end
    }

    public static function error(message:Dynamic):Void {
        #if cpp
        untyped __cpp__('printf("%s%s%s", "\033[1m\033[37m", "[ERROR] ", "\033[0m");');
        untyped __cpp__('printf("%s%s%s\n", "\033[1m\033[31m", message, "\033[0m");', Std.string(message));
        #elseif js
        untyped #if haxe4 js.Syntax.code #else __js__ #end ('console.log("%c[ERROR] " + Std.string(message), "color: red; font-weight: bold;")');
        #else
        println("[ERROR] " + "\033[1m\033[31m" + Std.string(message) + "\033[0m");
        #end
    }
    
    public static function success(message:Dynamic):Void {
        #if cpp
        untyped __cpp__('printf("%s%s%s", "\033[1m\033[37m", "[SUCCESS] ", "\033[0m");');
        untyped __cpp__('printf("%s%s%s\n", "\033[1m\033[32m", message, "\033[0m");', Std.string(message));
        #elseif js
        untyped #if haxe4 js.Syntax.code #else __js__ #end ('console.log("%c[SUCCESS] " + Std.string(message), "color: green; font-weight: bold;")');
        #else
        println("[SUCCESS] " + "\033[1m\033[32m" + Std.string(message) + "\033[0m");
        #end
    }

    private static inline function println(message:String):Void {
        #if sys
        Sys.println(Std.string(message));
        #else
        trace(Std.string(message));
        #end
    }
}