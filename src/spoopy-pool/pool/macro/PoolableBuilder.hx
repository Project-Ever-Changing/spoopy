package pool.macro;

#if macro
import pool.macro.MacroBase.*;
import haxe.macro.Context;
import haxe.macro.Type.ClassType;
import haxe.macro.Type.ClassField;
import haxe.macro.Expr;
using haxe.macro.ExprTools;
using haxe.macro.TypeTools;
using haxe.macro.ComplexTypeTools;

using pool.macro.MacroEx;


class PoolableBuilder
{
    public static function build(): Array<Field>
    {
        var fields: Array<Field> = Context.getBuildFields();

        /**
            Generate the linked next variable.
        **/
        if (!isBuildParentPoolable())
        {
            fields.push( generateLinkNextVar() );
        }


        /**
            Generate the reset method.
        **/
        var resetMethod: Field = generateResetMethod();
        if (resetMethod != null)
        {
            fields.push( resetMethod );
        }

        return fields;
    }


    static function generateLinkNextVar(): Field
    {
        var ct: ComplexType = Context.getLocalType().toComplexType();

        return {
            name: '_pool_next',
            pos: pos,
            kind: FVar(
                ct,
                macro null
            ),
            access: [ APublic ],
            meta: [{
                name: ':noCompletion',
                pos: pos
            }]
        };
    }


    static function generateResetMethod(): Field
    {
        var cl: ClassType = Context.getLocalClass().get();
        var ctor: Field = findBuildConstructor();
        if (ctor == null)
        {
            // There is no constructor here, check if there is a superclass that implements poolable.
            if (isBuildParentPoolable())
            {
                // Super class is poolable and there is no constructor.
                // A reset method is not necessary here.
                return null;
            }

            Context.error('Poolable classes require a constructor.', pos);
        }

        // Extract the function.
        var ctorFun: Function = switch ctor.kind
        {
            case FFun(f): f;
            default: Context.error('Constructor is not a function?', pos);
        }

        var resetExpr: ExprDef = ctorFun.expr.expr;
        switch resetExpr
        {
            case EBlock(exprs):
            {
                for (i in 0...exprs.length)
                {
                    exprs[i] = replaceSuperCall(exprs[i]);
                }
            }

            default: Context.error('Constructor is not a block?', pos);
        }

        // Create the reset method.
        return {
            name: getResetMethodName(cl),
            pos: pos,
            kind: cast ctor.kind,
            access: [ APublic ],
            meta: [{
                name: ':noCompletion',
                pos: pos
            }]
        };
    }


    static function findBuildConstructor(): Field
    {
        var fields: Array<Field> = Context.getBuildFields();

        for (field in fields)
        {
            if (field.name == 'new')
            {
                return field;
            }
        }

        return null;
    }


    static function replaceSuperCall(expr: Expr): Expr
    {
        switch expr.expr
        {
            case ECall(e, params):
            {
                switch e.expr
                {
                    case EConst(c):
                    {
                        switch c
                        {
                            case CIdent(s) if (s == "super"):
                            {
                                // Replace super constructor call with the call to the superclass reset method.
                                var superClass: ClassType = Context.getLocalClass().get().superClass.t.get();
                                var superClassResetMethodName: String = getResetMethodName(superClass);

                                return ECall(EConst(CIdent(superClassResetMethodName)).toExpr(), params).toExpr();
                            }

                            default:
                        }
                    }

                    default:
                }
            }

            default:
        }

        return expr;
    }


    static function isBuildParentPoolable(): Bool
    {
        var cl: ClassType = Context.getLocalClass().get();

        return cl.superClass != null && isPoolableType(cl.superClass.t.get());
    }
}
#end
