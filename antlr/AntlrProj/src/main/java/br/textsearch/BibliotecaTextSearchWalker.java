package br.textsearch;

import br.textsearch.parser.BibliotecaTextSearchBaseListener;
import br.textsearch.parser.BibliotecaTextSearchParser;
import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.TerminalNode;

public class BibliotecaTextSearchWalker extends BibliotecaTextSearchBaseListener {
    private final StringBuilder pesquisa;
    private String pesquisa_original;
    private boolean incluiParent;
    private boolean userParenPresent;
    private boolean boolOperPresent;
    private boolean temErro;

    private void abreParent() {
        if (incluiParent) {
            pesquisa.append(" ( ");
        }
    }

    private void closeParent() {
        if (incluiParent) {
            pesquisa.append(" ) ");
        }
    }

    public BibliotecaTextSearchWalker(final String pesquisa_original, boolean incluiParent) {
        this.pesquisa_original = pesquisa_original;
        this.pesquisa = new StringBuilder();
        this.incluiParent = incluiParent;
        this.userParenPresent = false;
        this.boolOperPresent = false;
        this.temErro = false;
    }

    @Override
    public void enterMultFat(BibliotecaTextSearchParser.MultFatContext ctx) {
        super.enterMultFat(ctx);
        abreParent();
    }

    @Override
    public void exitMultFat(BibliotecaTextSearchParser.MultFatContext ctx) {
        super.exitMultFat(ctx);
        closeParent();
    }

    @Override
    public void enterExpressao(BibliotecaTextSearchParser.ExpressaoContext ctx) {
        super.enterExpressao(ctx);
    }

    @Override
    public void exitExpressao(BibliotecaTextSearchParser.ExpressaoContext ctx) {
        super.exitExpressao(ctx);
    }

    @Override
    public void enterText(BibliotecaTextSearchParser.TextContext ctx) {
        super.enterText(ctx);
        for (char ch : ctx.getText().toCharArray()) {
            if (ch == '[' || ch == ']' || ch == '{' || ch == '}' ||
                    ch == '=' || ch == ':' || ch == '!' || ch == '@' ||
                    ch == '%' || ch == '^' || ch == '~' || ch == '(' || ch == ')') {
                pesquisa.append('\\');
                pesquisa.append(ch);
            } else {
                pesquisa.append(ch);
            }
        }
        pesquisa.append(" ");
    }

    @Override
    public void enterString(BibliotecaTextSearchParser.StringContext ctx) {
        super.enterString(ctx);
        for (char ch : ctx.getText().toCharArray()) {
            if (ch != '\'') {
                pesquisa.append(ch);
            }
        }
        pesquisa.append(" ");
    }

    @Override
    public void enterAnd_oper(BibliotecaTextSearchParser.And_operContext ctx) {
        super.enterAnd_oper(ctx);
        pesquisa.append(" && ");
        boolOperPresent = true;
    }

    @Override
    public void enterOr_oper(BibliotecaTextSearchParser.Or_operContext ctx) {
        super.enterOr_oper(ctx);
        pesquisa.append(" || ");
        boolOperPresent = true;
    }

    @Override
    public void enterNot_oper(BibliotecaTextSearchParser.Not_operContext ctx) {
        super.enterNot_oper(ctx);
        pesquisa.append(" - ");
        boolOperPresent = true;
    }

    @Override
    public void enterLparen(BibliotecaTextSearchParser.LparenContext ctx) {
        super.enterLparen(ctx);
        pesquisa.append(" ( ");
    }

    @Override
    public void enterRparen(BibliotecaTextSearchParser.RparenContext ctx) {
        super.enterRparen(ctx);
        pesquisa.append(" ) ");
        this.userParenPresent = true;
    }

    @Override
    public void visitErrorNode(ErrorNode node) {
        super.visitErrorNode(node);
        this.temErro = true;
    }

//    @Override
//    public void enterInvalidparent(BibliotecaTextSearchParser.InvalidparentContext ctx) {
//        super.enterInvalidparent(ctx);
//        pesquisa.deleteCharAt(pesquisa.length()-1);
//        pesquisa.append('\\');
//        pesquisa.append(ctx.getText());
//    }

    public String getPesquisa() {
        return pesquisa.toString();
    }

    public boolean isUserParenPresent() {
        return userParenPresent;
    }

    public boolean isBoolOperPresent() {
        return boolOperPresent;
    }

    public boolean isTemErro() {
        return temErro;
    }
}
