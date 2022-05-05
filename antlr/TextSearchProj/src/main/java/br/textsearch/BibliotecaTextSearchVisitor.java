// Generated from /home/evertonagilar/desenvolvimento/workspace_producao/TextSearchProj/src/main/resources/BibliotecaTextSearch.g4 by ANTLR 4.10.1
package br.textsearch;
import org.antlr.v4.runtime.tree.ParseTreeVisitor;

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link BibliotecaTextSearchParser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
public interface BibliotecaTextSearchVisitor<T> extends ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by {@link BibliotecaTextSearchParser#pesquisa}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPesquisa(BibliotecaTextSearchParser.PesquisaContext ctx);
	/**
	 * Visit a parse tree produced by {@link BibliotecaTextSearchParser#termo}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTermo(BibliotecaTextSearchParser.TermoContext ctx);
}