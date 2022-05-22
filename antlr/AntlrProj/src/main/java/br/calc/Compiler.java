package br.calc;

import br.calc.parser.CalcBaseVisitor;
import br.calc.parser.CalcLexer;
import br.calc.parser.CalcParser;
import org.antlr.v4.runtime.tree.RuleNode;

import java.util.HashMap;
import java.util.Map;

public class Compiler extends CalcBaseVisitor<Number> {
    private final Map<String, Number> variables = new HashMap<>();
    private final Map<String, RuleNode> functions = new HashMap<>();
    private final static Integer VOID = 0;

    @Override
    public Number visitExpression(CalcParser.ExpressionContext ctx) {
        if (ctx.LPARENT() != null) {
            return visit(ctx.inner);
        }
        if (ctx.operator != null) {
            switch (ctx.operator.getType()) {
                case (CalcLexer.POW_OP):
                    return doMathOperation(visit(ctx.left), visit(ctx.right), '^');
                case CalcLexer.MUL_OP:
                    return doMathOperation(visit(ctx.left), visit(ctx.right), '*');
                case CalcLexer.DIV_OP:
                    return doMathOperation(visit(ctx.left), visit(ctx.right), '/');
                case CalcLexer.ADD_OP:
                    return doMathOperation(visit(ctx.left), visit(ctx.right), '+');
                case CalcLexer.SUB_OP:
                    return doMathOperation(visit(ctx.left), visit(ctx.right), '-');
            }
        }
        return visit(ctx.fator());
    }

    @Override
    public Number visitInt(CalcParser.IntContext ctx) {
        return doNumber(ctx.getText(), true);
    }

    @Override
    public Number visitDouble(CalcParser.DoubleContext ctx) {
        return doNumber(ctx.getText(), false);
    }

    @Override
    public Number visitAssigment(CalcParser.AssigmentContext ctx) {
        String varName = ctx.ID().getText();
        Number result = visit(ctx.expression());
        variables.put(varName, result);
        return result;
    }

    @Override
    public Number visitFunctionCall(CalcParser.FunctionCallContext ctx) {
        Number result = 0;
        String functionName = ctx.ID().getText();
        RuleNode entry = functions.get(functionName);
        if (entry == null) {
            throw new CompilerException(ErrorMessages.UNDECLARED_FUNCTION, ctx);
        }
        return visit(entry);
    }

    @Override
    public Number visitFunctionDecl(CalcParser.FunctionDeclContext ctx) {
        String functionName = ctx.ID().getText();
        RuleNode entry = functions.get(functionName);
        if (entry != null) {
            throw new CompilerException(ErrorMessages.DUPLICATED_FUNCTION, ctx);
        }
        entry = ctx.statementBlock();
        functions.put(functionName, entry);
        return VOID;
    }

    @Override
    public Number visitVariableDecl(CalcParser.VariableDeclContext ctx) {
        String varName = ctx.ID().getText();
        if (variables.containsKey(varName)) {
            return variables.get(varName);
        }
        throw new CompilerException(ErrorMessages.UNDECLARED_VAR, ctx);
    }

    @Override
    public Number visitStatementBlock(CalcParser.StatementBlockContext ctx) {
        Number result = 0;
        for (CalcParser.StatementContext node : ctx.statement()) {
            result = visit(node);
            if (node.start.getType() == CalcLexer.RETURN) {
                return result;
            }
        }
        if (ctx.parent instanceof CalcParser.FunctionDeclContext) {
            throw new CompilerException(ErrorMessages.MISSING_RETURN_STATEMENT, ctx.parent);
        }
        return result;
    }

    @Override
    public Number visitReturn(CalcParser.ReturnContext ctx) {
        return visit(ctx.expression());
    }

    public void setVariable(final String Identifier, Number value) {
        variables.put(Identifier, value);
    }

    private Number doMathOperation(final Number left, final Number right, char operation) {
        if (left instanceof Double || right instanceof Double) {
            switch (operation) {
                case '+':
                    return left.doubleValue() + right.doubleValue();
                case '-':
                    return left.doubleValue() - right.doubleValue();
                case '*':
                    return left.doubleValue() * right.doubleValue();
                case '/':
                    return left.doubleValue() / right.doubleValue();
            }
        }
        switch (operation) {
            case '+':
                return left.intValue() + right.intValue();
            case '-':
                return left.intValue() - right.intValue();
            case '*':
                return left.intValue() * right.intValue();
            case '/':
                return left.intValue() / right.intValue();
            default:
                return Math.pow(left.doubleValue(), right.doubleValue());
        }
    }

    private Number doNumber(String text, boolean isInt) {
        if (isInt) {
            return Integer.parseInt(text);
        } else {
            return Double.parseDouble(text);
        }
    }

}