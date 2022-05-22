package br.calc;

import com.sun.istack.internal.NotNull;
import org.antlr.v4.runtime.tree.RuleNode;

public class CompilerException extends RuntimeException {
    public CompilerException(@NotNull final String message, RuleNode node) {
        super(message + node.getText());
    }
}
