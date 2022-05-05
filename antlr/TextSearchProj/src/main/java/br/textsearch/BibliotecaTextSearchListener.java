// Generated from /home/evertonagilar/desenvolvimento/workspace_producao/TextSearchProj/src/main/resources/BibliotecaTextSearch.g4 by ANTLR 4.10.1
package br.textsearch;
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link BibliotecaTextSearchParser}.
 */
public interface BibliotecaTextSearchListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link BibliotecaTextSearchParser#pesquisa}.
	 * @param ctx the parse tree
	 */
	void enterPesquisa(BibliotecaTextSearchParser.PesquisaContext ctx);
	/**
	 * Exit a parse tree produced by {@link BibliotecaTextSearchParser#pesquisa}.
	 * @param ctx the parse tree
	 */
	void exitPesquisa(BibliotecaTextSearchParser.PesquisaContext ctx);
	/**
	 * Enter a parse tree produced by {@link BibliotecaTextSearchParser#termo}.
	 * @param ctx the parse tree
	 */
	void enterTermo(BibliotecaTextSearchParser.TermoContext ctx);
	/**
	 * Exit a parse tree produced by {@link BibliotecaTextSearchParser#termo}.
	 * @param ctx the parse tree
	 */
	void exitTermo(BibliotecaTextSearchParser.TermoContext ctx);
}