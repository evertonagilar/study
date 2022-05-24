package br.calc;

import br.calc.parser.CalcBaseVisitor;
import br.calc.parser.CalcLexer;
import br.calc.parser.CalcParser;
import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.ParseTree;

import java.util.*;

public class Compiler extends CalcBaseVisitor<Number> {
    private final Map<String, Number> variables = new HashMap<>();
    private final Map<String, Function> functions = new HashMap<>();
    private final static Stack<Object> stack = new Stack<>();
    private final static Integer VOID = 0;
    private Number currentResult = VOID;

    @Override
    public Number visitProgram(CalcParser.ProgramContext ctx) {
        final Function mainFunc = new Function("main", null);
        final Frame frame = new Frame(mainFunc, null);
        stack.push(frame);
        int n = ctx.getChildCount();
        for (int i = 0; i < n; i++) {
            ParseTree c = ctx.getChild(i);
            currentResult = visit(c);
        }
        stack.pop();
        return currentResult;
    }

    @Override
    public Number visitScriptBlock(CalcParser.ScriptBlockContext ctx) {
        if (ctx.statementBlock() != null) {
            return visit(ctx.statementBlock());
        } else {
            Number result = currentResult;
            for (CalcParser.StatementContext stat : ctx.statement()) {
                result = visit(stat);
                if (stat.start.getType() == CalcLexer.RETURN) {
                    break;
                }
            }
            return result;
        }
    }

    @Override
    public Number visitStatementBlock(CalcParser.StatementBlockContext ctx) {
        Number result = currentResult;
        for (CalcParser.StatementContext stat : ctx.statement()) {
            result = visit(stat);
            if (stat.start.getType() == CalcLexer.RETURN) {
                break;
            }
        }
        return result;
    }

    @Override
    public Number visitStatement(CalcParser.StatementContext ctx) {
        ParseTree stat = ctx.getChild(0);
        Number result = visit(stat);
        currentResult = result;
        return result;
    }

    @Override
    public Number visitStatementRet(CalcParser.StatementRetContext ctx) {
        return currentResult;
    }

    @Override
    public Number visitExpression(CalcParser.ExpressionContext ctx) {
        if (ctx.LPARENT() != null) {
            return visit(ctx.inner);
        }
        if (ctx.operator != null) {
            final Number left = visit(ctx.left);
            final Number right = visit(ctx.right);
            return doMathOperation(left, right, ctx.operator.getType());
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
        final String varName = ctx.ID().getText();
        final Number result = visit(ctx.expression());
        variables.put(varName, result);
        return result;
    }

    @Override
    public Number visitFunctionCall(CalcParser.FunctionCallContext ctx) {
        final String functionName = ctx.ID().getText();
        final Function function = functions.get(functionName);
        if (function == null) {
            throw new CompilerException(ErrorMessages.UNDECLARED_FUNCTION, ctx);
        }
        final Frame frame = new Frame(function, ctx.statementRet());
        stack.push(frame); // Cria um frame a cada chamada de função
        visit(ctx.functionArgs());
        final Number result = visit(function.getStatementBlock());
        stack.pop();    // pop frame
        return result;
    }

    @Override
    public Number visitFunctionArgs(CalcParser.FunctionArgsContext ctx) {
        final Frame frame = (Frame) stack.peek();
        final Map<String, Number> localVars = frame.getLocalVars();
        final Iterator<CalcParser.FatorContext> args = ctx.fator().iterator();
        for (String paramName : frame.getFunction().getParams()) {
            if (args.hasNext()) {
                Number value = visit(args.next());
                localVars.put(paramName, value);
            } else {
                localVars.put(paramName, VOID);
            }
        }
        return currentResult;
    }

    @Override
    public Number visitFunctionDecl(CalcParser.FunctionDeclContext ctx) {
        final String functionName = ctx.ID().getText();
        Function function = functions.get(functionName);
        if (function != null) {
            throw new CompilerException(ErrorMessages.DUPLICATED_FUNCTION, ctx);
        }
        function = new Function(functionName, ctx.statementBlock());
        visit(ctx.functionParams());
        function.setParams((List<String>) stack.pop());
        functions.put(functionName, function);
        return VOID;
    }

    @Override
    public Number visitFunctionParams(CalcParser.FunctionParamsContext ctx) {
        final List<String> params = new ArrayList<>();
        ctx.ID().forEach(id -> params.add(id.getText()));
        stack.push(params);
        return VOID;
    }

    @Override
    public Number visitVariableDecl(CalcParser.VariableDeclContext ctx) {
        final String varName = ctx.ID().getText();
        if (!stack.isEmpty()) {
            final Frame frame = (Frame) stack.peek();
            if (frame.getLocalVars().containsKey(varName)) {
                return frame.getLocalVars().get(varName);
            }
        }
        if (variables.containsKey(varName)) {
            return variables.get(varName);
        }
        throw new CompilerException(ErrorMessages.UNDECLARED_VAR, ctx);
    }

    @Override
    public Number visitReturn(CalcParser.ReturnContext ctx) {
        return visit(ctx.expression());
    }

    @Override
    public Number visitIfDecl(CalcParser.IfDeclContext ctx) {
        final Number cond = visit(ctx.expression());
        if (cond.doubleValue() > 0) {
            return visit(ctx.trueStat);
        } else {
            if (ctx.falseStat != null) {
                return visit(ctx.falseStat);
            }
        }
        return currentResult;
    }

    public void setVariable(final String Identifier, Number value) {
        variables.put(Identifier, value);
    }

    private Number doMathOperation(final Number left, final Number right, int operation) {
        if (left instanceof Double || right instanceof Double) {
            switch (operation) {
                case CalcLexer.ADD_OP:
                    return left.doubleValue() + right.doubleValue();
                case CalcLexer.SUB_OP:
                    return left.doubleValue() - right.doubleValue();
                case CalcLexer.MUL_OP:
                    return left.doubleValue() * right.doubleValue();
                case CalcLexer.DIV_OP:
                    return left.doubleValue() / right.doubleValue();
                case CalcLexer.LT_OP:
                    return left.doubleValue() < right.doubleValue() ? 1 : 0;
                case CalcLexer.LTE_OP:
                    return left.doubleValue() <= right.doubleValue() ? 1 : 0;
                case CalcLexer.GT_OP:
                    return left.doubleValue() > right.doubleValue() ? 1 : 0;
                case CalcLexer.GTE_OP:
                    return left.doubleValue() >= right.doubleValue() ? 1 : 0;
                case CalcLexer.EQUAL_OP:
                    return left.doubleValue() == right.doubleValue() ? 1 : 0;
            }
        }
        switch (operation) {
            case CalcLexer.POW_OP:
                return Math.pow(left.doubleValue(), right.doubleValue());
            case CalcLexer.ADD_OP:
                return left.intValue() + right.intValue();
            case CalcLexer.SUB_OP:
                return left.intValue() - right.intValue();
            case CalcLexer.MUL_OP:
                return left.intValue() * right.intValue();
            case CalcLexer.DIV_OP:
                return left.intValue() / right.intValue();
            case CalcLexer.LT_OP:
                return left.intValue() < right.intValue() ? 1 : 0;
            case CalcLexer.LTE_OP:
                return left.intValue() <= right.intValue() ? 1 : 0;
            case CalcLexer.GT_OP:
                return left.intValue() > right.intValue() ? 1 : 0;
            case CalcLexer.GTE_OP:
                return left.intValue() >= right.intValue() ? 1 : 0;
            case CalcLexer.EQUAL_OP:
                return left.intValue() == right.intValue() ? 1 : 0;
        }
        return VOID;
    }

    private Number doNumber(String text, boolean isInt) {
        if (isInt) {
            return Integer.parseInt(text);
        } else {
            return Double.parseDouble(text);
        }
    }

    @Override
    public Number visitErrorNode(ErrorNode node) {
        return super.visitErrorNode(node);
    }


}