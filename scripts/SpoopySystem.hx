package;

class SpoopySystem {
    public static macro function getPWD():haxe.macro.Expr {
        return macro $v{Sys.getCwd()};
    }
}