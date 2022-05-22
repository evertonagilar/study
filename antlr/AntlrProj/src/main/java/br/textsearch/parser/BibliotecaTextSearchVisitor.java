// Generated from /home/evertonagilar/desenvolvimento/workspace_producao/TextSearchProj/src/main/resources/BibliotecaTextSearch.g4 by ANTLR 4.10.1
package br.textsearch.parser;
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
	 * Visit a parse tree produced by {@link BibliotecaTextSearchParser#expressao}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpressao(BibliotecaTextSearchParser.ExpressaoContext ctx);
	/**
	 * Visit a parse tree produced by the {@code MultFat}
	 * labeled alternative in {@link BibliotecaTextSearchParser#termo}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMultFat(BibliotecaTextSearchParser.MultFatContext ctx);
	/**
	 * Visit a parse tree produced by the {@code TermOrExpr}
	 * labeled alternative in {@link BibliotecaTextSearchParser#termo}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTermOrExpr(BibliotecaTextSearchParser.TermOrExprContext ctx);
	/**
	 * Visit a parse tree produced by the {@code TermAndExpr}
	 * labeled alternative in {@link BibliotecaTextSearchParser#termo}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTermAndExpr(BibliotecaTextSearchParser.TermAndExprContext ctx);
	/**
	 * Visit a parse tree produced by the {@code TermNotExpr}
	 * labeled alternative in {@link BibliotecaTextSearchParser#termo}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTermNotExpr(BibliotecaTextSearchParser.TermNotExprContext ctx);
	/**
	 * Visit a parse tree produced by {@link BibliotecaTextSearchParser#lparen}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLparen(BibliotecaTextSearchParser.LparenContext ctx);
	/**
	 * Visit a parse tree produced by {@link BibliotecaTextSearchParser#rparen}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRparen(BibliotecaTextSearchParser.RparenContext ctx);
	/**
	 * Visit a parse tree produced by {@link BibliotecaTextSearchParser#or_oper}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOr_oper(BibliotecaTextSearchParser.Or_operContext ctx);
	/**
	 * Visit a parse tree produced by {@link BibliotecaTextSearchParser#and_oper}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAnd_oper(BibliotecaTextSearchParser.And_operContext ctx);
	/**
	 * Visit a parse tree produced by {@link BibliotecaTextSearchParser#not_oper}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNot_oper(BibliotecaTextSearchParser.Not_operContext ctx);
	/**
	 * Visit a parse tree produced by the {@code Text}
	 * labeled alternative in {@link BibliotecaTextSearchParser#fator}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitText(BibliotecaTextSearchParser.TextContext ctx);
	/**
	 * Visit a parse tree produced by the {@code String}
	 * labeled alternative in {@link BibliotecaTextSearchParser#fator}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitString(BibliotecaTextSearchParser.StringContext ctx);
}