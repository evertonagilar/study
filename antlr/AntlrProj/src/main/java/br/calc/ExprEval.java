package br.calc;

import br.calc.parser.CalcLexer;
import br.calc.parser.CalcParser;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class ExprEval {
    private final Map<String, Number> variables = new HashMap<>();

    public void setVariable(final String identifier, Number value) {
        variables.put(identifier, value);
    }

    public Number execute(final String fileName){
        final CharStream stream;
        try {
            stream = CharStreams.fromFileName(fileName);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        return execute(stream);
    }

    public Number eval(final String expressao){
        final CharStream stream = CharStreams.fromString(expressao);
        return execute(stream);
    }

    public Number execute(final CharStream stream) {
        final CalcLexer lexer = new CalcLexer(stream);
        final CommonTokenStream tokens = new CommonTokenStream(lexer);
        final CalcParser parser = new CalcParser(tokens);
        final ParseTree tree = parser.program();
        final ParseTreeWalker walker = new ParseTreeWalker();
        final Compiler eval = new Compiler();
        variables.forEach((nome, value) -> eval.setVariable(nome, value));
        return eval.visit(tree);
    }
}
