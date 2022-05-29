package br.calc;

import org.antlr.v4.runtime.tree.RuleNode;

public class CompilerException extends RuntimeException {
<<<<<<< HEAD
    public CompilerException(final String message, RuleNode node) {
=======
    public CompilerException(final String message, final RuleNode node) {
>>>>>>> 97aed36565800c08c035de2a83c7a4fa50a2f3bd
        super(message + node.getText());
    }
}
