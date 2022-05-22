// Generated from /home/evertonagilar/desenvolvimento/workspace_producao/TextSearchProj/src/main/resources/BibliotecaTextSearch.g4 by ANTLR 4.10.1
package br.textsearch.parser;
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
	 * Enter a parse tree produced by {@link BibliotecaTextSearchParser#expressao}.
	 * @param ctx the parse tree
	 */
	void enterExpressao(BibliotecaTextSearchParser.ExpressaoContext ctx);
	/**
	 * Exit a parse tree produced by {@link BibliotecaTextSearchParser#expressao}.
	 * @param ctx the parse tree
	 */
	void exitExpressao(BibliotecaTextSearchParser.ExpressaoContext ctx);
	/**
	 * Enter a parse tree produced by the {@code MultFat}
	 * labeled alternative in {@link BibliotecaTextSearchParser#termo}.
	 * @param ctx the parse tree
	 */
	void enterMultFat(BibliotecaTextSearchParser.MultFatContext ctx);
	/**
	 * Exit a parse tree produced by the {@code MultFat}
	 * labeled alternative in {@link BibliotecaTextSearchParser#termo}.
	 * @param ctx the parse tree
	 */
	void exitMultFat(BibliotecaTextSearchParser.MultFatContext ctx);
	/**
	 * Enter a parse tree produced by the {@code TermOrExpr}
	 * labeled alternative in {@link BibliotecaTextSearchParser#termo}.
	 * @param ctx the parse tree
	 */
	void enterTermOrExpr(BibliotecaTextSearchParser.TermOrExprContext ctx);
	/**
	 * Exit a parse tree produced by the {@code TermOrExpr}
	 * labeled alternative in {@link BibliotecaTextSearchParser#termo}.
	 * @param ctx the parse tree
	 */
	void exitTermOrExpr(BibliotecaTextSearchParser.TermOrExprContext ctx);
	/**
	 * Enter a parse tree produced by the {@code TermAndExpr}
	 * labeled alternative in {@link BibliotecaTextSearchParser#termo}.
	 * @param ctx the parse tree
	 */
	void enterTermAndExpr(BibliotecaTextSearchParser.TermAndExprContext ctx);
	/**
	 * Exit a parse tree produced by the {@code TermAndExpr}
	 * labeled alternative in {@link BibliotecaTextSearchParser#termo}.
	 * @param ctx the parse tree
	 */
	void exitTermAndExpr(BibliotecaTextSearchParser.TermAndExprContext ctx);
	/**
	 * Enter a parse tree produced by the {@code TermNotExpr}
	 * labeled alternative in {@link BibliotecaTextSearchParser#termo}.
	 * @param ctx the parse tree
	 */
	void enterTermNotExpr(BibliotecaTextSearchParser.TermNotExprContext ctx);
	/**
	 * Exit a parse tree produced by the {@code TermNotExpr}
	 * labeled alternative in {@link BibliotecaTextSearchParser#termo}.
	 * @param ctx the parse tree
	 */
	void exitTermNotExpr(BibliotecaTextSearchParser.TermNotExprContext ctx);
	/**
	 * Enter a parse tree produced by {@link BibliotecaTextSearchParser#lparen}.
	 * @param ctx the parse tree
	 */
	void enterLparen(BibliotecaTextSearchParser.LparenContext ctx);
	/**
	 * Exit a parse tree produced by {@link BibliotecaTextSearchParser#lparen}.
	 * @param ctx the parse tree
	 */
	void exitLparen(BibliotecaTextSearchParser.LparenContext ctx);
	/**
	 * Enter a parse tree produced by {@link BibliotecaTextSearchParser#rparen}.
	 * @param ctx the parse tree
	 */
	void enterRparen(BibliotecaTextSearchParser.RparenContext ctx);
	/**
	 * Exit a parse tree produced by {@link BibliotecaTextSearchParser#rparen}.
	 * @param ctx the parse tree
	 */
	void exitRparen(BibliotecaTextSearchParser.RparenContext ctx);
	/**
	 * Enter a parse tree produced by {@link BibliotecaTextSearchParser#or_oper}.
	 * @param ctx the parse tree
	 */
	void enterOr_oper(BibliotecaTextSearchParser.Or_operContext ctx);
	/**
	 * Exit a parse tree produced by {@link BibliotecaTextSearchParser#or_oper}.
	 * @param ctx the parse tree
	 */
	void exitOr_oper(BibliotecaTextSearchParser.Or_operContext ctx);
	/**
	 * Enter a parse tree produced by {@link BibliotecaTextSearchParser#and_oper}.
	 * @param ctx the parse tree
	 */
	void enterAnd_oper(BibliotecaTextSearchParser.And_operContext ctx);
	/**
	 * Exit a parse tree produced by {@link BibliotecaTextSearchParser#and_oper}.
	 * @param ctx the parse tree
	 */
	void exitAnd_oper(BibliotecaTextSearchParser.And_operContext ctx);
	/**
	 * Enter a parse tree produced by {@link BibliotecaTextSearchParser#not_oper}.
	 * @param ctx the parse tree
	 */
	void enterNot_oper(BibliotecaTextSearchParser.Not_operContext ctx);
	/**
	 * Exit a parse tree produced by {@link BibliotecaTextSearchParser#not_oper}.
	 * @param ctx the parse tree
	 */
	void exitNot_oper(BibliotecaTextSearchParser.Not_operContext ctx);
	/**
	 * Enter a parse tree produced by the {@code Text}
	 * labeled alternative in {@link BibliotecaTextSearchParser#fator}.
	 * @param ctx the parse tree
	 */
	void enterText(BibliotecaTextSearchParser.TextContext ctx);
	/**
	 * Exit a parse tree produced by the {@code Text}
	 * labeled alternative in {@link BibliotecaTextSearchParser#fator}.
	 * @param ctx the parse tree
	 */
	void exitText(BibliotecaTextSearchParser.TextContext ctx);
	/**
	 * Enter a parse tree produced by the {@code String}
	 * labeled alternative in {@link BibliotecaTextSearchParser#fator}.
	 * @param ctx the parse tree
	 */
	void enterString(BibliotecaTextSearchParser.StringContext ctx);
	/**
	 * Exit a parse tree produced by the {@code String}
	 * labeled alternative in {@link BibliotecaTextSearchParser#fator}.
	 * @param ctx the parse tree
	 */
	void exitString(BibliotecaTextSearchParser.StringContext ctx);
}