// Generated from /home/evertonagilar/study/antlr/AntlrProj/src/main/resources/Calc.g4 by ANTLR 4.10.1
package br.calc.parser;
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class CalcLexer extends Lexer {
	static { RuntimeMetaData.checkVersion("4.10.1", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, IF=2, ELSE=3, ADD_OP=4, SUB_OP=5, MUL_OP=6, DIV_OP=7, POW_OP=8, 
		EQUAL_OP=9, ASSIGN_OP=10, LT_OP=11, LTE_OP=12, GT_OP=13, GTE_OP=14, LPARENT=15, 
		RPARENT=16, BEGIN_BLOCK=17, END_BLOCK=18, STATEMENT_RET=19, RETURN=20, 
		ID=21, INT=22, DOUBLE=23, NUMBER=24, END=25, NEWLINE=26, WS=27;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	private static String[] makeRuleNames() {
		return new String[] {
			"T__0", "LETTER", "DIGIT", "IF", "ELSE", "ADD_OP", "SUB_OP", "MUL_OP", 
			"DIV_OP", "POW_OP", "EQUAL_OP", "ASSIGN_OP", "LT_OP", "LTE_OP", "GT_OP", 
			"GTE_OP", "LPARENT", "RPARENT", "BEGIN_BLOCK", "END_BLOCK", "STATEMENT_RET", 
			"RETURN", "ID", "INT", "DOUBLE", "NUMBER", "END", "NEWLINE", "WS"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "','", "'if'", "'else'", "'+'", "'-'", "'*'", "'/'", "'^'", "'=='", 
			"'='", "'<'", "'<='", "'>'", "'>='", "'('", "')'", "'{'", "'}'", "';'", 
			"'return'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, "IF", "ELSE", "ADD_OP", "SUB_OP", "MUL_OP", "DIV_OP", "POW_OP", 
			"EQUAL_OP", "ASSIGN_OP", "LT_OP", "LTE_OP", "GT_OP", "GTE_OP", "LPARENT", 
			"RPARENT", "BEGIN_BLOCK", "END_BLOCK", "STATEMENT_RET", "RETURN", "ID", 
			"INT", "DOUBLE", "NUMBER", "END", "NEWLINE", "WS"
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


	public CalcLexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "Calc.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public String[] getChannelNames() { return channelNames; }

	@Override
	public String[] getModeNames() { return modeNames; }

	@Override
	public ATN getATN() { return _ATN; }

	public static final String _serializedATN =
		"\u0004\u0000\u001b\u00a8\u0006\uffff\uffff\u0002\u0000\u0007\u0000\u0002"+
		"\u0001\u0007\u0001\u0002\u0002\u0007\u0002\u0002\u0003\u0007\u0003\u0002"+
		"\u0004\u0007\u0004\u0002\u0005\u0007\u0005\u0002\u0006\u0007\u0006\u0002"+
		"\u0007\u0007\u0007\u0002\b\u0007\b\u0002\t\u0007\t\u0002\n\u0007\n\u0002"+
		"\u000b\u0007\u000b\u0002\f\u0007\f\u0002\r\u0007\r\u0002\u000e\u0007\u000e"+
		"\u0002\u000f\u0007\u000f\u0002\u0010\u0007\u0010\u0002\u0011\u0007\u0011"+
		"\u0002\u0012\u0007\u0012\u0002\u0013\u0007\u0013\u0002\u0014\u0007\u0014"+
		"\u0002\u0015\u0007\u0015\u0002\u0016\u0007\u0016\u0002\u0017\u0007\u0017"+
		"\u0002\u0018\u0007\u0018\u0002\u0019\u0007\u0019\u0002\u001a\u0007\u001a"+
		"\u0002\u001b\u0007\u001b\u0002\u001c\u0007\u001c\u0001\u0000\u0001\u0000"+
		"\u0001\u0001\u0001\u0001\u0001\u0002\u0001\u0002\u0001\u0003\u0001\u0003"+
		"\u0001\u0003\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0004"+
		"\u0001\u0005\u0001\u0005\u0001\u0006\u0001\u0006\u0001\u0007\u0001\u0007"+
		"\u0001\b\u0001\b\u0001\t\u0001\t\u0001\n\u0001\n\u0001\n\u0001\u000b\u0001"+
		"\u000b\u0001\f\u0001\f\u0001\r\u0001\r\u0001\r\u0001\u000e\u0001\u000e"+
		"\u0001\u000f\u0001\u000f\u0001\u000f\u0001\u0010\u0001\u0010\u0001\u0011"+
		"\u0001\u0011\u0001\u0012\u0001\u0012\u0001\u0013\u0001\u0013\u0001\u0014"+
		"\u0001\u0014\u0001\u0015\u0001\u0015\u0001\u0015\u0001\u0015\u0001\u0015"+
		"\u0001\u0015\u0001\u0015\u0001\u0016\u0001\u0016\u0003\u0016v\b\u0016"+
		"\u0001\u0016\u0001\u0016\u0001\u0016\u0005\u0016{\b\u0016\n\u0016\f\u0016"+
		"~\t\u0016\u0001\u0017\u0004\u0017\u0081\b\u0017\u000b\u0017\f\u0017\u0082"+
		"\u0001\u0018\u0004\u0018\u0086\b\u0018\u000b\u0018\f\u0018\u0087\u0001"+
		"\u0018\u0001\u0018\u0004\u0018\u008c\b\u0018\u000b\u0018\f\u0018\u008d"+
		"\u0003\u0018\u0090\b\u0018\u0001\u0019\u0001\u0019\u0003\u0019\u0094\b"+
		"\u0019\u0001\u001a\u0001\u001a\u0001\u001a\u0001\u001a\u0001\u001b\u0003"+
		"\u001b\u009b\b\u001b\u0001\u001b\u0001\u001b\u0004\u001b\u009f\b\u001b"+
		"\u000b\u001b\f\u001b\u00a0\u0001\u001b\u0001\u001b\u0001\u001c\u0001\u001c"+
		"\u0001\u001c\u0001\u001c\u0000\u0000\u001d\u0001\u0001\u0003\u0000\u0005"+
		"\u0000\u0007\u0002\t\u0003\u000b\u0004\r\u0005\u000f\u0006\u0011\u0007"+
		"\u0013\b\u0015\t\u0017\n\u0019\u000b\u001b\f\u001d\r\u001f\u000e!\u000f"+
		"#\u0010%\u0011\'\u0012)\u0013+\u0014-\u0015/\u00161\u00173\u00185\u0019"+
		"7\u001a9\u001b\u0001\u0000\u0003\u0002\u0000AZaz\u0001\u000009\u0002\u0000"+
		"\r\r  \u00b1\u0000\u0001\u0001\u0000\u0000\u0000\u0000\u0007\u0001\u0000"+
		"\u0000\u0000\u0000\t\u0001\u0000\u0000\u0000\u0000\u000b\u0001\u0000\u0000"+
		"\u0000\u0000\r\u0001\u0000\u0000\u0000\u0000\u000f\u0001\u0000\u0000\u0000"+
		"\u0000\u0011\u0001\u0000\u0000\u0000\u0000\u0013\u0001\u0000\u0000\u0000"+
		"\u0000\u0015\u0001\u0000\u0000\u0000\u0000\u0017\u0001\u0000\u0000\u0000"+
		"\u0000\u0019\u0001\u0000\u0000\u0000\u0000\u001b\u0001\u0000\u0000\u0000"+
		"\u0000\u001d\u0001\u0000\u0000\u0000\u0000\u001f\u0001\u0000\u0000\u0000"+
		"\u0000!\u0001\u0000\u0000\u0000\u0000#\u0001\u0000\u0000\u0000\u0000%"+
		"\u0001\u0000\u0000\u0000\u0000\'\u0001\u0000\u0000\u0000\u0000)\u0001"+
		"\u0000\u0000\u0000\u0000+\u0001\u0000\u0000\u0000\u0000-\u0001\u0000\u0000"+
		"\u0000\u0000/\u0001\u0000\u0000\u0000\u00001\u0001\u0000\u0000\u0000\u0000"+
		"3\u0001\u0000\u0000\u0000\u00005\u0001\u0000\u0000\u0000\u00007\u0001"+
		"\u0000\u0000\u0000\u00009\u0001\u0000\u0000\u0000\u0001;\u0001\u0000\u0000"+
		"\u0000\u0003=\u0001\u0000\u0000\u0000\u0005?\u0001\u0000\u0000\u0000\u0007"+
		"A\u0001\u0000\u0000\u0000\tD\u0001\u0000\u0000\u0000\u000bI\u0001\u0000"+
		"\u0000\u0000\rK\u0001\u0000\u0000\u0000\u000fM\u0001\u0000\u0000\u0000"+
		"\u0011O\u0001\u0000\u0000\u0000\u0013Q\u0001\u0000\u0000\u0000\u0015S"+
		"\u0001\u0000\u0000\u0000\u0017V\u0001\u0000\u0000\u0000\u0019X\u0001\u0000"+
		"\u0000\u0000\u001bZ\u0001\u0000\u0000\u0000\u001d]\u0001\u0000\u0000\u0000"+
		"\u001f_\u0001\u0000\u0000\u0000!b\u0001\u0000\u0000\u0000#d\u0001\u0000"+
		"\u0000\u0000%f\u0001\u0000\u0000\u0000\'h\u0001\u0000\u0000\u0000)j\u0001"+
		"\u0000\u0000\u0000+l\u0001\u0000\u0000\u0000-u\u0001\u0000\u0000\u0000"+
		"/\u0080\u0001\u0000\u0000\u00001\u0085\u0001\u0000\u0000\u00003\u0093"+
		"\u0001\u0000\u0000\u00005\u0095\u0001\u0000\u0000\u00007\u009e\u0001\u0000"+
		"\u0000\u00009\u00a4\u0001\u0000\u0000\u0000;<\u0005,\u0000\u0000<\u0002"+
		"\u0001\u0000\u0000\u0000=>\u0007\u0000\u0000\u0000>\u0004\u0001\u0000"+
		"\u0000\u0000?@\u0007\u0001\u0000\u0000@\u0006\u0001\u0000\u0000\u0000"+
		"AB\u0005i\u0000\u0000BC\u0005f\u0000\u0000C\b\u0001\u0000\u0000\u0000"+
		"DE\u0005e\u0000\u0000EF\u0005l\u0000\u0000FG\u0005s\u0000\u0000GH\u0005"+
		"e\u0000\u0000H\n\u0001\u0000\u0000\u0000IJ\u0005+\u0000\u0000J\f\u0001"+
		"\u0000\u0000\u0000KL\u0005-\u0000\u0000L\u000e\u0001\u0000\u0000\u0000"+
		"MN\u0005*\u0000\u0000N\u0010\u0001\u0000\u0000\u0000OP\u0005/\u0000\u0000"+
		"P\u0012\u0001\u0000\u0000\u0000QR\u0005^\u0000\u0000R\u0014\u0001\u0000"+
		"\u0000\u0000ST\u0005=\u0000\u0000TU\u0005=\u0000\u0000U\u0016\u0001\u0000"+
		"\u0000\u0000VW\u0005=\u0000\u0000W\u0018\u0001\u0000\u0000\u0000XY\u0005"+
		"<\u0000\u0000Y\u001a\u0001\u0000\u0000\u0000Z[\u0005<\u0000\u0000[\\\u0005"+
		"=\u0000\u0000\\\u001c\u0001\u0000\u0000\u0000]^\u0005>\u0000\u0000^\u001e"+
		"\u0001\u0000\u0000\u0000_`\u0005>\u0000\u0000`a\u0005=\u0000\u0000a \u0001"+
		"\u0000\u0000\u0000bc\u0005(\u0000\u0000c\"\u0001\u0000\u0000\u0000de\u0005"+
		")\u0000\u0000e$\u0001\u0000\u0000\u0000fg\u0005{\u0000\u0000g&\u0001\u0000"+
		"\u0000\u0000hi\u0005}\u0000\u0000i(\u0001\u0000\u0000\u0000jk\u0005;\u0000"+
		"\u0000k*\u0001\u0000\u0000\u0000lm\u0005r\u0000\u0000mn\u0005e\u0000\u0000"+
		"no\u0005t\u0000\u0000op\u0005u\u0000\u0000pq\u0005r\u0000\u0000qr\u0005"+
		"n\u0000\u0000r,\u0001\u0000\u0000\u0000sv\u0003\u0003\u0001\u0000tv\u0005"+
		"_\u0000\u0000us\u0001\u0000\u0000\u0000ut\u0001\u0000\u0000\u0000v|\u0001"+
		"\u0000\u0000\u0000w{\u0003\u0003\u0001\u0000x{\u0003\u0005\u0002\u0000"+
		"y{\u0005_\u0000\u0000zw\u0001\u0000\u0000\u0000zx\u0001\u0000\u0000\u0000"+
		"zy\u0001\u0000\u0000\u0000{~\u0001\u0000\u0000\u0000|z\u0001\u0000\u0000"+
		"\u0000|}\u0001\u0000\u0000\u0000}.\u0001\u0000\u0000\u0000~|\u0001\u0000"+
		"\u0000\u0000\u007f\u0081\u0003\u0005\u0002\u0000\u0080\u007f\u0001\u0000"+
		"\u0000\u0000\u0081\u0082\u0001\u0000\u0000\u0000\u0082\u0080\u0001\u0000"+
		"\u0000\u0000\u0082\u0083\u0001\u0000\u0000\u0000\u00830\u0001\u0000\u0000"+
		"\u0000\u0084\u0086\u0003\u0005\u0002\u0000\u0085\u0084\u0001\u0000\u0000"+
		"\u0000\u0086\u0087\u0001\u0000\u0000\u0000\u0087\u0085\u0001\u0000\u0000"+
		"\u0000\u0087\u0088\u0001\u0000\u0000\u0000\u0088\u008f\u0001\u0000\u0000"+
		"\u0000\u0089\u008b\u0005.\u0000\u0000\u008a\u008c\u0003\u0005\u0002\u0000"+
		"\u008b\u008a\u0001\u0000\u0000\u0000\u008c\u008d\u0001\u0000\u0000\u0000"+
		"\u008d\u008b\u0001\u0000\u0000\u0000\u008d\u008e\u0001\u0000\u0000\u0000"+
		"\u008e\u0090\u0001\u0000\u0000\u0000\u008f\u0089\u0001\u0000\u0000\u0000"+
		"\u008f\u0090\u0001\u0000\u0000\u0000\u00902\u0001\u0000\u0000\u0000\u0091"+
		"\u0094\u0003/\u0017\u0000\u0092\u0094\u00031\u0018\u0000\u0093\u0091\u0001"+
		"\u0000\u0000\u0000\u0093\u0092\u0001\u0000\u0000\u0000\u00944\u0001\u0000"+
		"\u0000\u0000\u0095\u0096\u0005\u0000\u0000\u0001\u0096\u0097\u0001\u0000"+
		"\u0000\u0000\u0097\u0098\u0006\u001a\u0000\u0000\u00986\u0001\u0000\u0000"+
		"\u0000\u0099\u009b\u0005\r\u0000\u0000\u009a\u0099\u0001\u0000\u0000\u0000"+
		"\u009a\u009b\u0001\u0000\u0000\u0000\u009b\u009c\u0001\u0000\u0000\u0000"+
		"\u009c\u009f\u0005\n\u0000\u0000\u009d\u009f\u0005\r\u0000\u0000\u009e"+
		"\u009a\u0001\u0000\u0000\u0000\u009e\u009d\u0001\u0000\u0000\u0000\u009f"+
		"\u00a0\u0001\u0000\u0000\u0000\u00a0\u009e\u0001\u0000\u0000\u0000\u00a0"+
		"\u00a1\u0001\u0000\u0000\u0000\u00a1\u00a2\u0001\u0000\u0000\u0000\u00a2"+
		"\u00a3\u0006\u001b\u0000\u0000\u00a38\u0001\u0000\u0000\u0000\u00a4\u00a5"+
		"\u0007\u0002\u0000\u0000\u00a5\u00a6\u0001\u0000\u0000\u0000\u00a6\u00a7"+
		"\u0006\u001c\u0000\u0000\u00a7:\u0001\u0000\u0000\u0000\f\u0000uz|\u0082"+
		"\u0087\u008d\u008f\u0093\u009a\u009e\u00a0\u0001\u0006\u0000\u0000";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}