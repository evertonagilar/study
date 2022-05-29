// Generated from /home/evertonagilar/study/antlr/AntlrProj/src/main/resources/Calc.g4 by ANTLR 4.10.1
package br.calc.parser;
import org.antlr.v4.runtime.tree.ParseTreeVisitor;

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link CalcParser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
public interface CalcVisitor<T> extends ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by {@link CalcParser#main}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMain(CalcParser.MainContext ctx);
	/**
	 * Visit a parse tree produced by {@link CalcParser#statementBlock}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStatementBlock(CalcParser.StatementBlockContext ctx);
	/**
	 * Visit a parse tree produced by {@link CalcParser#statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStatement(CalcParser.StatementContext ctx);
	/**
	 * Visit a parse tree produced by {@link CalcParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpression(CalcParser.ExpressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link CalcParser#assigment}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssigment(CalcParser.AssigmentContext ctx);
	/**
	 * Visit a parse tree produced by {@link CalcParser#functionCall}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFunctionCall(CalcParser.FunctionCallContext ctx);
	/**
	 * Visit a parse tree produced by {@link CalcParser#functionDecl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFunctionDecl(CalcParser.FunctionDeclContext ctx);
	/**
	 * Visit a parse tree produced by {@link CalcParser#return}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitReturn(CalcParser.ReturnContext ctx);
	/**
	 * Visit a parse tree produced by {@link CalcParser#fator}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFator(CalcParser.FatorContext ctx);
	/**
	 * Visit a parse tree produced by the {@code Int}
	 * labeled alternative in {@link CalcParser#number}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInt(CalcParser.IntContext ctx);
	/**
	 * Visit a parse tree produced by the {@code Double}
	 * labeled alternative in {@link CalcParser#number}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDouble(CalcParser.DoubleContext ctx);
	/**
	 * Visit a parse tree produced by {@link CalcParser#identifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIdentifier(CalcParser.IdentifierContext ctx);
	/**
	 * Visit a parse tree produced by {@link CalcParser#variableDecl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVariableDecl(CalcParser.VariableDeclContext ctx);
}