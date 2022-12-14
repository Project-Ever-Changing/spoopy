package;

import haxe.macro.Expr;

/*
* I was stuck with this issue for 3 days lmao.
Solution: https://community.openfl.org/t/is-there-a-way-to-get-the-working-directory-of-the-lime-project/9098/10
*/
class SpoopySystem {
    public static macro function getPWD():Expr {
        return macro $v{Sys.getCwd()};
    }
}