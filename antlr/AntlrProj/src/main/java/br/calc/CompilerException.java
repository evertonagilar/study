package br.calc;

import org.antlr.v4.runtime.tree.RuleNode;

public class CompilerException extends RuntimeException {
    public CompilerException(final String message, final RuleNode node) {
        super(message + node.getText());
    }
}
