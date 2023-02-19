package pool.macro;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type.ClassType;
import haxe.io.Path;
using haxe.macro.ExprTools;
using haxe.macro.Tools;
using haxe.macro.TypeTools;
using haxe.macro.ComplexTypeTools;
using sys.FileSystem;
using StringTools;


class MacroEx
{
    public static function toExpr(exprDef: ExprDef): Expr
    {
        return {
            expr: exprDef,
            pos: Context.currentPos()
        };
    }


    public static function getTypeString(cl: ClassType): String
    {
        if (cl.pack.length == 0)
        {
            return cl.name;
        }
        else
        {
            return cl.pack.join('_') + '_' + cl.name;
        }
    }
}
#end
