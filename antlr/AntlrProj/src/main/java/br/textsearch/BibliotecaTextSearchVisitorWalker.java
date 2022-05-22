package br.textsearch;

import br.textsearch.parser.BibliotecaTextSearchBaseVisitor;
import org.antlr.v4.runtime.tree.ErrorNode;

public class BibliotecaTextSearchVisitorWalker extends BibliotecaTextSearchBaseVisitor<String> {

    @Override
    public String visitErrorNode(ErrorNode node) {
        if (node.getText().equals(")")){
            return "\\)";
        }
        return super.visitErrorNode(node);
    }
}
