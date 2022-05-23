package br.calc;

import br.calc.parser.CalcBaseVisitor;
import br.calc.parser.CalcLexer;
import br.calc.parser.CalcParser;
import org.antlr.v4.runtime.tree.*;

import java.util.*;

public class Compiler extends CalcBaseVisitor<Number> {
    private final Map<String, Number> variables = new HashMap<>();
    private final Map<String, Function> functions = new HashMap<>();
    private final static Stack<Object> stack = new Stack<>();
    private final static Integer VOID = 0;

    @Override
    public Number visitMain(CalcParser.MainContext ctx) {
        int n = ctx.getChildCount();
        Number result = VOID;
        for (int i=0; i < n; i++){
            ParseTree c = ctx.getChild(i);
            if (!c.getText().equals(";")) {
                result = visit(c);
            }
        }
        return result;
    }

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
        stack.push(function);
        visit(ctx.functionArgs());
        final Number result = visit(function.getStatementBlock());
        stack.pop();    // pop local vars
        return result;
    }

    @Override
    public Number visitFunctionArgs(CalcParser.FunctionArgsContext ctx) {
        final Function function = (Function) stack.pop();
        final Map<String, Number> localVars = new HashMap<>();
        final Iterator<CalcParser.FatorContext> args = ctx.fator().iterator();
        for (String paramName : function.getParams()){
            if (args.hasNext()){
                Number value = visit(args.next());
                localVars.put(paramName, value);
            }else{
                localVars.put(paramName, VOID);
            }
        }
        stack.push(localVars);
        return VOID;
    }

    @Override
    public Number visitFunctionDecl(CalcParser.FunctionDeclContext ctx) {
        final String functionName = ctx.ID().getText();
        Function function = functions.get(functionName);
        if (function != null) {
            throw new CompilerException(ErrorMessages.DUPLICATED_FUNCTION, ctx);
        }
        function = new Function();
        function.setName(functionName);
        function.setStatementBlock(ctx.statementBlock());
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
        if (!stack.isEmpty()){
            Object localVars = stack.peek();
            if (localVars != null && localVars instanceof Map){
                if (((Map)localVars).containsKey(varName)) {
                    return (Number) ((Map)localVars).get(varName);
                }
            }
        }
        if (variables.containsKey(varName)) {
            return variables.get(varName);
        }
        throw new CompilerException(ErrorMessages.UNDECLARED_VAR, ctx);
    }

    @Override
    public Number visitStatementBlock(CalcParser.StatementBlockContext ctx) {
        Number result = 0;
        int n = ctx.getChildCount();
        for (int i=0; i < n; i++){
            ParseTree c = ctx.getChild(i);
            if (c.getClass() == CalcParser.StatementContext.class ||
                c.getClass() == CalcParser.StatementBlockContext.class){
                result = visit(c);
            }
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

    @Override
    public Number visitErrorNode(ErrorNode node) {
        return super.visitErrorNode(node);
    }
}