// Generated from /home/evertonagilar/desenvolvimento/workspace_producao/AntlrProj/src/main/resources/Calc.g4 by ANTLR 4.10.1
package br.calc.parser;
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link CalcParser}.
 */
public interface CalcListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link CalcParser#main}.
	 * @param ctx the parse tree
	 */
	void enterMain(CalcParser.MainContext ctx);
	/**
	 * Exit a parse tree produced by {@link CalcParser#main}.
	 * @param ctx the parse tree
	 */
	void exitMain(CalcParser.MainContext ctx);
	/**
	 * Enter a parse tree produced by {@link CalcParser#statementBlock}.
	 * @param ctx the parse tree
	 */
	void enterStatementBlock(CalcParser.StatementBlockContext ctx);
	/**
	 * Exit a parse tree produced by {@link CalcParser#statementBlock}.
	 * @param ctx the parse tree
	 */
	void exitStatementBlock(CalcParser.StatementBlockContext ctx);
	/**
	 * Enter a parse tree produced by {@link CalcParser#statement}.
	 * @param ctx the parse tree
	 */
	void enterStatement(CalcParser.StatementContext ctx);
	/**
	 * Exit a parse tree produced by {@link CalcParser#statement}.
	 * @param ctx the parse tree
	 */
	void exitStatement(CalcParser.StatementContext ctx);
	/**
	 * Enter a parse tree produced by {@link CalcParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterExpression(CalcParser.ExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link CalcParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitExpression(CalcParser.ExpressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link CalcParser#assigment}.
	 * @param ctx the parse tree
	 */
	void enterAssigment(CalcParser.AssigmentContext ctx);
	/**
	 * Exit a parse tree produced by {@link CalcParser#assigment}.
	 * @param ctx the parse tree
	 */
	void exitAssigment(CalcParser.AssigmentContext ctx);
	/**
	 * Enter a parse tree produced by {@link CalcParser#functionCall}.
	 * @param ctx the parse tree
	 */
	void enterFunctionCall(CalcParser.FunctionCallContext ctx);
	/**
	 * Exit a parse tree produced by {@link CalcParser#functionCall}.
	 * @param ctx the parse tree
	 */
	void exitFunctionCall(CalcParser.FunctionCallContext ctx);
	/**
	 * Enter a parse tree produced by {@link CalcParser#functionDecl}.
	 * @param ctx the parse tree
	 */
	void enterFunctionDecl(CalcParser.FunctionDeclContext ctx);
	/**
	 * Exit a parse tree produced by {@link CalcParser#functionDecl}.
	 * @param ctx the parse tree
	 */
	void exitFunctionDecl(CalcParser.FunctionDeclContext ctx);
	/**
	 * Enter a parse tree produced by {@link CalcParser#return}.
	 * @param ctx the parse tree
	 */
	void enterReturn(CalcParser.ReturnContext ctx);
	/**
	 * Exit a parse tree produced by {@link CalcParser#return}.
	 * @param ctx the parse tree
	 */
	void exitReturn(CalcParser.ReturnContext ctx);
	/**
	 * Enter a parse tree produced by {@link CalcParser#fator}.
	 * @param ctx the parse tree
	 */
	void enterFator(CalcParser.FatorContext ctx);
	/**
	 * Exit a parse tree produced by {@link CalcParser#fator}.
	 * @param ctx the parse tree
	 */
	void exitFator(CalcParser.FatorContext ctx);
	/**
	 * Enter a parse tree produced by the {@code Int}
	 * labeled alternative in {@link CalcParser#number}.
	 * @param ctx the parse tree
	 */
	void enterInt(CalcParser.IntContext ctx);
	/**
	 * Exit a parse tree produced by the {@code Int}
	 * labeled alternative in {@link CalcParser#number}.
	 * @param ctx the parse tree
	 */
	void exitInt(CalcParser.IntContext ctx);
	/**
	 * Enter a parse tree produced by the {@code Double}
	 * labeled alternative in {@link CalcParser#number}.
	 * @param ctx the parse tree
	 */
	void enterDouble(CalcParser.DoubleContext ctx);
	/**
	 * Exit a parse tree produced by the {@code Double}
	 * labeled alternative in {@link CalcParser#number}.
	 * @param ctx the parse tree
	 */
	void exitDouble(CalcParser.DoubleContext ctx);
	/**
	 * Enter a parse tree produced by {@link CalcParser#identifier}.
	 * @param ctx the parse tree
	 */
	void enterIdentifier(CalcParser.IdentifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link CalcParser#identifier}.
	 * @param ctx the parse tree
	 */
	void exitIdentifier(CalcParser.IdentifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link CalcParser#variableDecl}.
	 * @param ctx the parse tree
	 */
	void enterVariableDecl(CalcParser.VariableDeclContext ctx);
	/**
	 * Exit a parse tree produced by {@link CalcParser#variableDecl}.
	 * @param ctx the parse tree
	 */
	void exitVariableDecl(CalcParser.VariableDeclContext ctx);
}