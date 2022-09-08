package spoopy.system;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
using haxe.macro.Tools;
#end

class SpoopyUtils {

    /*
     * Method taken from the offical Haxe Code Cookbook website:
     * https://code.haxe.org/category/macros/enum-abstract-values.html
     */
    public static macro function getEnumValues(path:Expr):Expr {
        var type = Context.getType(path.toString());

        switch (type.follow()) {
            case TAbstract(_.get() => ab, _) if (ab.meta.has(":enum")):
                var valueExprs = [];

                for (field in ab.impl.get().statics.get()) {
                    if(field.meta.has(":enum") && field.meta.has(":impl")) {
                        var fieldName = field.name;
                        valueExprs.push(macro $path.$fieldName);
                    }
                }

                return macro $a{valueExprs};
            default:
                throw new Error(path.toString()+ " should be @:enum abstract", path.pos);
        }
    }
}