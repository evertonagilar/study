// Generated from /home/evertonagilar/desenvolvimento/workspace_producao/TextSearchProj/src/main/resources/BibliotecaTextSearch.g4 by ANTLR 4.10.1
package br.textsearch.parser;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class BibliotecaTextSearchParser extends Parser {
	static { RuntimeMetaData.checkVersion("4.10.1", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		ASPA_SIMPLES=1, WHITESPACE=2, LPAREN=3, RPAREN=4, OR=5, AND=6, NOT=7, 
		STRING=8, TEXT=9, SPECIAL_CHAR=10, NEWLINE=11, END=12;
	public static final int
		RULE_pesquisa = 0, RULE_expressao = 1, RULE_termo = 2, RULE_lparen = 3, 
		RULE_rparen = 4, RULE_or_oper = 5, RULE_and_oper = 6, RULE_not_oper = 7, 
		RULE_fator = 8;
	private static String[] makeRuleNames() {
		return new String[] {
			"pesquisa", "expressao", "termo", "lparen", "rparen", "or_oper", "and_oper", 
			"not_oper", "fator"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "'''", null, "'('", "')'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, "ASPA_SIMPLES", "WHITESPACE", "LPAREN", "RPAREN", "OR", "AND", 
			"NOT", "STRING", "TEXT", "SPECIAL_CHAR", "NEWLINE", "END"
		};
	}
	private static final String[] _SYMBOLIC_NAMES = makeSymbolicNames();
	public static final Vocabulary VOCABULARY = new VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

	/**
	 * @deprecated Use {@link #VOCABULARY} instead.
	 */
	@Deprecated
	public static final String[] tokenNames;
	static {
		tokenNames = new String[_SYMBOLIC_NAMES.length];
		for (int i = 0; i < tokenNames.length; i++) {
			tokenNames[i] = VOCABULARY.getLiteralName(i);
			if (tokenNames[i] == null) {
				tokenNames[i] = VOCABULARY.getSymbolicName(i);
			}

			if (tokenNames[i] == null) {
				tokenNames[i] = "<INVALID>";
			}
		}
	}

	@Override
	@Deprecated
	public String[] getTokenNames() {
		return tokenNames;
	}

	@Override

	public Vocabulary getVocabulary() {
		return VOCABULARY;
	}

	@Override
	public String getGrammarFileName() { return "BibliotecaTextSearch.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }

	public BibliotecaTextSearchParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	public static class PesquisaContext extends ParserRuleContext {
		public List<ExpressaoContext> expressao() {
			return getRuleContexts(ExpressaoContext.class);
		}
		public ExpressaoContext expressao(int i) {
			return getRuleContext(ExpressaoContext.class,i);
		}
		public PesquisaContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_pesquisa; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).enterPesquisa(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).exitPesquisa(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof BibliotecaTextSearchVisitor ) return ((BibliotecaTextSearchVisitor<? extends T>)visitor).visitPesquisa(this);
			else return visitor.visitChildren(this);
		}
	}

	public final PesquisaContext pesquisa() throws RecognitionException {
		PesquisaContext _localctx = new PesquisaContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_pesquisa);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(19); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(18);
				expressao();
				}
				}
				setState(21); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << LPAREN) | (1L << STRING) | (1L << TEXT))) != 0) );
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ExpressaoContext extends ParserRuleContext {
		public LparenContext lparen() {
			return getRuleContext(LparenContext.class,0);
		}
		public List<ExpressaoContext> expressao() {
			return getRuleContexts(ExpressaoContext.class);
		}
		public ExpressaoContext expressao(int i) {
			return getRuleContext(ExpressaoContext.class,i);
		}
		public RparenContext rparen() {
			return getRuleContext(RparenContext.class,0);
		}
		public Or_operContext or_oper() {
			return getRuleContext(Or_operContext.class,0);
		}
		public And_operContext and_oper() {
			return getRuleContext(And_operContext.class,0);
		}
		public Not_operContext not_oper() {
			return getRuleContext(Not_operContext.class,0);
		}
		public TermoContext termo() {
			return getRuleContext(TermoContext.class,0);
		}
		public ExpressaoContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_expressao; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).enterExpressao(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).exitExpressao(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof BibliotecaTextSearchVisitor ) return ((BibliotecaTextSearchVisitor<? extends T>)visitor).visitExpressao(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ExpressaoContext expressao() throws RecognitionException {
		ExpressaoContext _localctx = new ExpressaoContext(_ctx, getState());
		enterRule(_localctx, 2, RULE_expressao);
		try {
			setState(36);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case LPAREN:
				enterOuterAlt(_localctx, 1);
				{
				setState(23);
				lparen();
				setState(24);
				expressao();
				setState(25);
				rparen();
				setState(33);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,2,_ctx) ) {
				case 1:
					{
					setState(29);
					_errHandler.sync(this);
					switch (_input.LA(1)) {
					case OR:
						{
						setState(26);
						or_oper();
						}
						break;
					case AND:
						{
						setState(27);
						and_oper();
						}
						break;
					case NOT:
						{
						setState(28);
						not_oper();
						}
						break;
					default:
						throw new NoViableAltException(this);
					}
					setState(31);
					expressao();
					}
					break;
				}
				}
				break;
			case STRING:
			case TEXT:
				enterOuterAlt(_localctx, 2);
				{
				setState(35);
				termo(0);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class TermoContext extends ParserRuleContext {
		public TermoContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_termo; }
	 
		public TermoContext() { }
		public void copyFrom(TermoContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class MultFatContext extends TermoContext {
		public List<FatorContext> fator() {
			return getRuleContexts(FatorContext.class);
		}
		public FatorContext fator(int i) {
			return getRuleContext(FatorContext.class,i);
		}
		public MultFatContext(TermoContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).enterMultFat(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).exitMultFat(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof BibliotecaTextSearchVisitor ) return ((BibliotecaTextSearchVisitor<? extends T>)visitor).visitMultFat(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class TermOrExprContext extends TermoContext {
		public TermoContext termo() {
			return getRuleContext(TermoContext.class,0);
		}
		public Or_operContext or_oper() {
			return getRuleContext(Or_operContext.class,0);
		}
		public ExpressaoContext expressao() {
			return getRuleContext(ExpressaoContext.class,0);
		}
		public TermOrExprContext(TermoContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).enterTermOrExpr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).exitTermOrExpr(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof BibliotecaTextSearchVisitor ) return ((BibliotecaTextSearchVisitor<? extends T>)visitor).visitTermOrExpr(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class TermAndExprContext extends TermoContext {
		public TermoContext termo() {
			return getRuleContext(TermoContext.class,0);
		}
		public And_operContext and_oper() {
			return getRuleContext(And_operContext.class,0);
		}
		public ExpressaoContext expressao() {
			return getRuleContext(ExpressaoContext.class,0);
		}
		public TermAndExprContext(TermoContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).enterTermAndExpr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).exitTermAndExpr(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof BibliotecaTextSearchVisitor ) return ((BibliotecaTextSearchVisitor<? extends T>)visitor).visitTermAndExpr(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class TermNotExprContext extends TermoContext {
		public TermoContext termo() {
			return getRuleContext(TermoContext.class,0);
		}
		public Not_operContext not_oper() {
			return getRuleContext(Not_operContext.class,0);
		}
		public ExpressaoContext expressao() {
			return getRuleContext(ExpressaoContext.class,0);
		}
		public TermNotExprContext(TermoContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).enterTermNotExpr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).exitTermNotExpr(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof BibliotecaTextSearchVisitor ) return ((BibliotecaTextSearchVisitor<? extends T>)visitor).visitTermNotExpr(this);
			else return visitor.visitChildren(this);
		}
	}

	public final TermoContext termo() throws RecognitionException {
		return termo(0);
	}

	private TermoContext termo(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		TermoContext _localctx = new TermoContext(_ctx, _parentState);
		TermoContext _prevctx = _localctx;
		int _startState = 4;
		enterRecursionRule(_localctx, 4, RULE_termo, _p);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			{
			_localctx = new MultFatContext(_localctx);
			_ctx = _localctx;
			_prevctx = _localctx;

			setState(40); 
			_errHandler.sync(this);
			_alt = 1;
			do {
				switch (_alt) {
				case 1:
					{
					{
					setState(39);
					fator();
					}
					}
					break;
				default:
					throw new NoViableAltException(this);
				}
				setState(42); 
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,4,_ctx);
			} while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER );
			}
			_ctx.stop = _input.LT(-1);
			setState(58);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,6,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(56);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,5,_ctx) ) {
					case 1:
						{
						_localctx = new TermOrExprContext(new TermoContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_termo);
						setState(44);
						if (!(precpred(_ctx, 3))) throw new FailedPredicateException(this, "precpred(_ctx, 3)");
						setState(45);
						or_oper();
						setState(46);
						expressao();
						}
						break;
					case 2:
						{
						_localctx = new TermAndExprContext(new TermoContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_termo);
						setState(48);
						if (!(precpred(_ctx, 2))) throw new FailedPredicateException(this, "precpred(_ctx, 2)");
						setState(49);
						and_oper();
						setState(50);
						expressao();
						}
						break;
					case 3:
						{
						_localctx = new TermNotExprContext(new TermoContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_termo);
						setState(52);
						if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
						setState(53);
						not_oper();
						setState(54);
						expressao();
						}
						break;
					}
					} 
				}
				setState(60);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,6,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	public static class LparenContext extends ParserRuleContext {
		public TerminalNode LPAREN() { return getToken(BibliotecaTextSearchParser.LPAREN, 0); }
		public LparenContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_lparen; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).enterLparen(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).exitLparen(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof BibliotecaTextSearchVisitor ) return ((BibliotecaTextSearchVisitor<? extends T>)visitor).visitLparen(this);
			else return visitor.visitChildren(this);
		}
	}

	public final LparenContext lparen() throws RecognitionException {
		LparenContext _localctx = new LparenContext(_ctx, getState());
		enterRule(_localctx, 6, RULE_lparen);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(61);
			match(LPAREN);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class RparenContext extends ParserRuleContext {
		public TerminalNode RPAREN() { return getToken(BibliotecaTextSearchParser.RPAREN, 0); }
		public RparenContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_rparen; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).enterRparen(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).exitRparen(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof BibliotecaTextSearchVisitor ) return ((BibliotecaTextSearchVisitor<? extends T>)visitor).visitRparen(this);
			else return visitor.visitChildren(this);
		}
	}

	public final RparenContext rparen() throws RecognitionException {
		RparenContext _localctx = new RparenContext(_ctx, getState());
		enterRule(_localctx, 8, RULE_rparen);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(63);
			match(RPAREN);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Or_operContext extends ParserRuleContext {
		public TerminalNode OR() { return getToken(BibliotecaTextSearchParser.OR, 0); }
		public Or_operContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_or_oper; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).enterOr_oper(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).exitOr_oper(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof BibliotecaTextSearchVisitor ) return ((BibliotecaTextSearchVisitor<? extends T>)visitor).visitOr_oper(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Or_operContext or_oper() throws RecognitionException {
		Or_operContext _localctx = new Or_operContext(_ctx, getState());
		enterRule(_localctx, 10, RULE_or_oper);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(65);
			match(OR);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class And_operContext extends ParserRuleContext {
		public TerminalNode AND() { return getToken(BibliotecaTextSearchParser.AND, 0); }
		public And_operContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_and_oper; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).enterAnd_oper(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).exitAnd_oper(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof BibliotecaTextSearchVisitor ) return ((BibliotecaTextSearchVisitor<? extends T>)visitor).visitAnd_oper(this);
			else return visitor.visitChildren(this);
		}
	}

	public final And_operContext and_oper() throws RecognitionException {
		And_operContext _localctx = new And_operContext(_ctx, getState());
		enterRule(_localctx, 12, RULE_and_oper);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(67);
			match(AND);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Not_operContext extends ParserRuleContext {
		public TerminalNode NOT() { return getToken(BibliotecaTextSearchParser.NOT, 0); }
		public Not_operContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_not_oper; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).enterNot_oper(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).exitNot_oper(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof BibliotecaTextSearchVisitor ) return ((BibliotecaTextSearchVisitor<? extends T>)visitor).visitNot_oper(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Not_operContext not_oper() throws RecognitionException {
		Not_operContext _localctx = new Not_operContext(_ctx, getState());
		enterRule(_localctx, 14, RULE_not_oper);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(69);
			match(NOT);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class FatorContext extends ParserRuleContext {
		public FatorContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_fator; }
	 
		public FatorContext() { }
		public void copyFrom(FatorContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class TextContext extends FatorContext {
		public TerminalNode TEXT() { return getToken(BibliotecaTextSearchParser.TEXT, 0); }
		public TextContext(FatorContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).enterText(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).exitText(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof BibliotecaTextSearchVisitor ) return ((BibliotecaTextSearchVisitor<? extends T>)visitor).visitText(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class StringContext extends FatorContext {
		public TerminalNode STRING() { return getToken(BibliotecaTextSearchParser.STRING, 0); }
		public StringContext(FatorContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).enterString(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof BibliotecaTextSearchListener ) ((BibliotecaTextSearchListener)listener).exitString(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof BibliotecaTextSearchVisitor ) return ((BibliotecaTextSearchVisitor<? extends T>)visitor).visitString(this);
			else return visitor.visitChildren(this);
		}
	}

	public final FatorContext fator() throws RecognitionException {
		FatorContext _localctx = new FatorContext(_ctx, getState());
		enterRule(_localctx, 16, RULE_fator);
		try {
			setState(73);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case TEXT:
				_localctx = new TextContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(71);
				match(TEXT);
				}
				break;
			case STRING:
				_localctx = new StringContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(72);
				match(STRING);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public boolean sempred(RuleContext _localctx, int ruleIndex, int predIndex) {
		switch (ruleIndex) {
		case 2:
			return termo_sempred((TermoContext)_localctx, predIndex);
		}
		return true;
	}
	private boolean termo_sempred(TermoContext _localctx, int predIndex) {
		switch (predIndex) {
		case 0:
			return precpred(_ctx, 3);
		case 1:
			return precpred(_ctx, 2);
		case 2:
			return precpred(_ctx, 1);
		}
		return true;
	}

	public static final String _serializedATN =
		"\u0004\u0001\fL\u0002\u0000\u0007\u0000\u0002\u0001\u0007\u0001\u0002"+
		"\u0002\u0007\u0002\u0002\u0003\u0007\u0003\u0002\u0004\u0007\u0004\u0002"+
		"\u0005\u0007\u0005\u0002\u0006\u0007\u0006\u0002\u0007\u0007\u0007\u0002"+
		"\b\u0007\b\u0001\u0000\u0004\u0000\u0014\b\u0000\u000b\u0000\f\u0000\u0015"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0003\u0001\u001e\b\u0001\u0001\u0001\u0001\u0001\u0003\u0001\"\b\u0001"+
		"\u0001\u0001\u0003\u0001%\b\u0001\u0001\u0002\u0001\u0002\u0004\u0002"+
		")\b\u0002\u000b\u0002\f\u0002*\u0001\u0002\u0001\u0002\u0001\u0002\u0001"+
		"\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0002\u0001"+
		"\u0002\u0001\u0002\u0001\u0002\u0005\u00029\b\u0002\n\u0002\f\u0002<\t"+
		"\u0002\u0001\u0003\u0001\u0003\u0001\u0004\u0001\u0004\u0001\u0005\u0001"+
		"\u0005\u0001\u0006\u0001\u0006\u0001\u0007\u0001\u0007\u0001\b\u0001\b"+
		"\u0003\bJ\b\b\u0001\b\u0000\u0001\u0004\t\u0000\u0002\u0004\u0006\b\n"+
		"\f\u000e\u0010\u0000\u0000L\u0000\u0013\u0001\u0000\u0000\u0000\u0002"+
		"$\u0001\u0000\u0000\u0000\u0004&\u0001\u0000\u0000\u0000\u0006=\u0001"+
		"\u0000\u0000\u0000\b?\u0001\u0000\u0000\u0000\nA\u0001\u0000\u0000\u0000"+
		"\fC\u0001\u0000\u0000\u0000\u000eE\u0001\u0000\u0000\u0000\u0010I\u0001"+
		"\u0000\u0000\u0000\u0012\u0014\u0003\u0002\u0001\u0000\u0013\u0012\u0001"+
		"\u0000\u0000\u0000\u0014\u0015\u0001\u0000\u0000\u0000\u0015\u0013\u0001"+
		"\u0000\u0000\u0000\u0015\u0016\u0001\u0000\u0000\u0000\u0016\u0001\u0001"+
		"\u0000\u0000\u0000\u0017\u0018\u0003\u0006\u0003\u0000\u0018\u0019\u0003"+
		"\u0002\u0001\u0000\u0019!\u0003\b\u0004\u0000\u001a\u001e\u0003\n\u0005"+
		"\u0000\u001b\u001e\u0003\f\u0006\u0000\u001c\u001e\u0003\u000e\u0007\u0000"+
		"\u001d\u001a\u0001\u0000\u0000\u0000\u001d\u001b\u0001\u0000\u0000\u0000"+
		"\u001d\u001c\u0001\u0000\u0000\u0000\u001e\u001f\u0001\u0000\u0000\u0000"+
		"\u001f \u0003\u0002\u0001\u0000 \"\u0001\u0000\u0000\u0000!\u001d\u0001"+
		"\u0000\u0000\u0000!\"\u0001\u0000\u0000\u0000\"%\u0001\u0000\u0000\u0000"+
		"#%\u0003\u0004\u0002\u0000$\u0017\u0001\u0000\u0000\u0000$#\u0001\u0000"+
		"\u0000\u0000%\u0003\u0001\u0000\u0000\u0000&(\u0006\u0002\uffff\uffff"+
		"\u0000\')\u0003\u0010\b\u0000(\'\u0001\u0000\u0000\u0000)*\u0001\u0000"+
		"\u0000\u0000*(\u0001\u0000\u0000\u0000*+\u0001\u0000\u0000\u0000+:\u0001"+
		"\u0000\u0000\u0000,-\n\u0003\u0000\u0000-.\u0003\n\u0005\u0000./\u0003"+
		"\u0002\u0001\u0000/9\u0001\u0000\u0000\u000001\n\u0002\u0000\u000012\u0003"+
		"\f\u0006\u000023\u0003\u0002\u0001\u000039\u0001\u0000\u0000\u000045\n"+
		"\u0001\u0000\u000056\u0003\u000e\u0007\u000067\u0003\u0002\u0001\u0000"+
		"79\u0001\u0000\u0000\u00008,\u0001\u0000\u0000\u000080\u0001\u0000\u0000"+
		"\u000084\u0001\u0000\u0000\u00009<\u0001\u0000\u0000\u0000:8\u0001\u0000"+
		"\u0000\u0000:;\u0001\u0000\u0000\u0000;\u0005\u0001\u0000\u0000\u0000"+
		"<:\u0001\u0000\u0000\u0000=>\u0005\u0003\u0000\u0000>\u0007\u0001\u0000"+
		"\u0000\u0000?@\u0005\u0004\u0000\u0000@\t\u0001\u0000\u0000\u0000AB\u0005"+
		"\u0005\u0000\u0000B\u000b\u0001\u0000\u0000\u0000CD\u0005\u0006\u0000"+
		"\u0000D\r\u0001\u0000\u0000\u0000EF\u0005\u0007\u0000\u0000F\u000f\u0001"+
		"\u0000\u0000\u0000GJ\u0005\t\u0000\u0000HJ\u0005\b\u0000\u0000IG\u0001"+
		"\u0000\u0000\u0000IH\u0001\u0000\u0000\u0000J\u0011\u0001\u0000\u0000"+
		"\u0000\b\u0015\u001d!$*8:I";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}