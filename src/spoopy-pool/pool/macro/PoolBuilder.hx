package pool.macro;

#if macro
import pool.macro.MacroBase.*;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type.ClassType;
import haxe.macro.Type;
using haxe.macro.Tools;
using haxe.macro.TypeTools;
using haxe.macro.ExprTools;
using StringTools;


class PoolBuilder extends MacroBase
{
    @IgnoreCover
    public static function build(path: Expr, generateStatic: Bool = true): Array<Field>
    {
        var fields: Array<Field> = Context.getBuildFields();

        var getPutAccess: Array<Access> = [ APublic, AInline ];
        var poolVarAccess: Array<Access> = [];

        if (generateStatic)
        {
            getPutAccess.push(AStatic);
            poolVarAccess.push(AStatic);
        }

        var poolableTypes: Array<ClassType> = getPoolableTypes(path);

        for (poolableType in poolableTypes)
        {
            var ct: ComplexType = TPath({ pack: poolableType.pack, name: poolableType.name });
            var pack: String = ct.toString();

            // Generate pool var for object.
            var poolVarName: String = getPoolVarName(poolableType);
            var resetMethodName: String = getResetMethodName(poolableType);
            fields.push({
                name: poolVarName,
                pos: pos,
                access: poolVarAccess,
                kind: FVar(
                    ct,
                    macro null
                ),
                meta: [{
                    name: ':noCompletion',
                    pos: pos
                }]
            });

            // Generate get method.
            var args: Array<FunctionArg> = getConstructorArgs(poolableType);
            var argsStr: String = joinArgNames(args);
            var getMethodBody: String = '
            {
                if ($poolVarName == null)
                {
                    return new $pack($argsStr);
                }
                else
                {
                    trace("Already Exist");

                    var tmp: $pack = $poolVarName;
                    $poolVarName = cast $poolVarName._pool_next;

                    tmp._pool_next = null;
                    tmp.$resetMethodName($argsStr);

                    return tmp;
                }
            }';
            fields.push({
                name: 'get${poolableType.name}',
                pos: pos,
                access: getPutAccess,
                kind: FFun({
                    args: args,
                    ret: ct,
                    expr: Context.parse(getMethodBody, pos)
                })
            });

            // Generate put method.
            var putMethodBody: String = '
            {
                if (item != null)
                {
                    item._pool_next = cast $poolVarName;
                    $poolVarName = item;
                }
            }';
            fields.push({
                name: 'put${poolableType.name}',
                pos: pos,
                access: getPutAccess,
                kind: FFun({
                    args: [{
                        name: 'item',
                        type: ct
                    }],
                    ret: null,
                    expr: Context.parse(putMethodBody, pos)
                })
            });

            // Generate dispose method
            var disposeMethodBody: String = '
            {

            }';
        }

        return fields;
    }


    static function joinArgNames(args: Array<FunctionArg>): String
    {
        var buf: StringBuf = new StringBuf();

        for (i in 0...args.length)
        {
            var arg: String = args[i].name;

            if (i > 0) buf.add(', ');

            buf.add(arg);
        }

        return buf.toString();
    }


    static function getPoolableTypes(path: Expr): Array<ClassType>
    {
        var types: Array<ClassType> = new Array();

        var packages = getPackagesInPath(path);

        for (p in packages)
        {
            var cl: ClassType = tryGetClassType(p);
            if (cl == null) continue;

            if (isPoolableType(cl))
            {
                types.push(cl);
            }
        }

        return types;
    }


    static function tryGetClassType(pkg: String): ClassType
    {
        try
        {
            return Context.getType(pkg).follow().getClass();
        }
        catch (ex: Any)
        {
            return null;
        }
    }


    static function getConstructorArgs(cl: ClassType): Array<FunctionArg>
    {
        var ctor: ClassField = cl.constructor.get();
        if (ctor == null)
        {
            Context.error('Poolable classes require a constructor.', pos);
        }

        var ctorArgs: Array<FunctionArg> = [];

        switch ctor.type.follow()
        {
            case TFun(args, ret):
            {
                for (arg in args)
                {
                    ctorArgs.push({
                        name: arg.name,
                        type: arg.t.toComplexType(),
                        opt: arg.opt,
                    });
                }
            }

            default: Context.error('Error in getConstructorArgs() (${ctor.type.follow()})', pos);
        }

        return ctorArgs;
    }
}
#end
