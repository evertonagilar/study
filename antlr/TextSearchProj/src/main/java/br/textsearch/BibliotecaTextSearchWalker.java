package br.textsearch;

public class BibliotecaTextSearchWalker extends BibliotecaTextSearchBaseListener {

    @Override
    public void enterPesquisa(BibliotecaTextSearchParser.PesquisaContext ctx) {
        super.enterPesquisa(ctx);
        System.out.println(ctx.getText());
    }

}
