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

using pool.macro.MacroEx;


class MacroBase
{
    public static var pos(get, never): Position;
    inline static function get_pos(): Position { return Context.currentPos(); }


    public static function getResetMethodName(cl: ClassType): String
    {
        return '_pool_reset_${cl.getTypeString()}';
    }


    public static function getPoolVarName(cl: ClassType): String
    {
        return '_pool_${cl.getTypeString()}';
    }


    public static function isPoolableType(cl: ClassType): Bool
    {
        for (intf in cl.interfaces)
        {
            if (intf.t.toString() == "pool.Poolable")
            {
                return true;
            }
        }

        if (cl.superClass != null)
        {
            return isPoolableType(cl.superClass.t.get());
        }

        return false;
    }


    public static function getPackagesInPath(path: Expr): Array<String>
    {
        var pathStr: String = switch(path.expr)
        {
            case EConst(CString(s)): s;
            case _: path.toString();
        }

        if(~/[^a-zA-Z0-9_.]/.match(pathStr))
        {
            Context.error('Invalid path.', pos);
            return [];
        }

        var pack: Array<String> = pathStr.split('.');
        var relativePath: String = Path.join(pack);

        var packages: Array<String> = [];

        for (classPath in Context.getClassPath())
        {
            traverse(packages, Path.join([classPath, relativePath]), pathStr, true);
        }

        return packages;
    }


    public static function traverse(packages: Array<String>, dir: String, path: String, recursive: Bool)
    {
        if (!dir.exists())
        {
            return;
        }

        if (path.startsWith('.'))
        {
            path = path.substr(1);
        }

        for (file in dir.readDirectory())
        {
            var fullPath: String = Path.join([dir, file]);

            if (fullPath.isDirectory() && recursive)
            {
                traverse(packages, fullPath, '$path.$file', true);
                continue;
            }

            if (file.substr(-3) != '.hx')
            {
                continue;
            }

            var className: String = file.substr(0, file.length - 3);
            if (className == '')
            {
                continue;
            }

            if (path == '' || path == '.')
            {
                packages.push(className);
            }
            else
            {
                packages.push('$path.$className');
            }
        }
    }


    public static function print(v: Dynamic)
    {
        #if (sys && macro && UNIT_TEST)
        Sys.println(v);
        #end
    }
}
#end
