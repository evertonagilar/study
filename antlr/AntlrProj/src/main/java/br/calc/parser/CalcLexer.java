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
		ADD_OP=1, SUB_OP=2, MUL_OP=3, DIV_OP=4, POW_OP=5, ASSIGN_OP=6, LPARENT=7, 
		RPARENT=8, BEGIN_BLOCK=9, END_BLOCK=10, STATEMENT_RET=11, RETURN=12, ID=13, 
		INT=14, DOUBLE=15, NUMBER=16, END=17, NEWLINE=18, WS=19;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	private static String[] makeRuleNames() {
		return new String[] {
			"LETTER", "DIGIT", "ADD_OP", "SUB_OP", "MUL_OP", "DIV_OP", "POW_OP", 
			"ASSIGN_OP", "LPARENT", "RPARENT", "BEGIN_BLOCK", "END_BLOCK", "STATEMENT_RET", 
			"RETURN", "ID", "INT", "DOUBLE", "NUMBER", "END", "NEWLINE", "WS"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "'+'", "'-'", "'*'", "'/'", "'^'", "'='", "'('", "')'", "'{'", 
			"'}'", "';'", "'return'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, "ADD_OP", "SUB_OP", "MUL_OP", "DIV_OP", "POW_OP", "ASSIGN_OP", 
			"LPARENT", "RPARENT", "BEGIN_BLOCK", "END_BLOCK", "STATEMENT_RET", "RETURN", 
			"ID", "INT", "DOUBLE", "NUMBER", "END", "NEWLINE", "WS"
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
		"\u0004\u0000\u0013\u0081\u0006\uffff\uffff\u0002\u0000\u0007\u0000\u0002"+
		"\u0001\u0007\u0001\u0002\u0002\u0007\u0002\u0002\u0003\u0007\u0003\u0002"+
		"\u0004\u0007\u0004\u0002\u0005\u0007\u0005\u0002\u0006\u0007\u0006\u0002"+
		"\u0007\u0007\u0007\u0002\b\u0007\b\u0002\t\u0007\t\u0002\n\u0007\n\u0002"+
		"\u000b\u0007\u000b\u0002\f\u0007\f\u0002\r\u0007\r\u0002\u000e\u0007\u000e"+
		"\u0002\u000f\u0007\u000f\u0002\u0010\u0007\u0010\u0002\u0011\u0007\u0011"+
		"\u0002\u0012\u0007\u0012\u0002\u0013\u0007\u0013\u0002\u0014\u0007\u0014"+
		"\u0001\u0000\u0001\u0000\u0001\u0001\u0001\u0001\u0001\u0002\u0001\u0002"+
		"\u0001\u0003\u0001\u0003\u0001\u0004\u0001\u0004\u0001\u0005\u0001\u0005"+
		"\u0001\u0006\u0001\u0006\u0001\u0007\u0001\u0007\u0001\b\u0001\b\u0001"+
		"\t\u0001\t\u0001\n\u0001\n\u0001\u000b\u0001\u000b\u0001\f\u0001\f\u0001"+
		"\r\u0001\r\u0001\r\u0001\r\u0001\r\u0001\r\u0001\r\u0001\u000e\u0001\u000e"+
		"\u0003\u000eO\b\u000e\u0001\u000e\u0001\u000e\u0001\u000e\u0005\u000e"+
		"T\b\u000e\n\u000e\f\u000eW\t\u000e\u0001\u000f\u0004\u000fZ\b\u000f\u000b"+
		"\u000f\f\u000f[\u0001\u0010\u0004\u0010_\b\u0010\u000b\u0010\f\u0010`"+
		"\u0001\u0010\u0001\u0010\u0004\u0010e\b\u0010\u000b\u0010\f\u0010f\u0003"+
		"\u0010i\b\u0010\u0001\u0011\u0001\u0011\u0003\u0011m\b\u0011\u0001\u0012"+
		"\u0001\u0012\u0001\u0012\u0001\u0012\u0001\u0013\u0003\u0013t\b\u0013"+
		"\u0001\u0013\u0001\u0013\u0004\u0013x\b\u0013\u000b\u0013\f\u0013y\u0001"+
		"\u0013\u0001\u0013\u0001\u0014\u0001\u0014\u0001\u0014\u0001\u0014\u0000"+
		"\u0000\u0015\u0001\u0000\u0003\u0000\u0005\u0001\u0007\u0002\t\u0003\u000b"+
		"\u0004\r\u0005\u000f\u0006\u0011\u0007\u0013\b\u0015\t\u0017\n\u0019\u000b"+
		"\u001b\f\u001d\r\u001f\u000e!\u000f#\u0010%\u0011\'\u0012)\u0013\u0001"+
		"\u0000\u0003\u0002\u0000AZaz\u0001\u000009\u0002\u0000\r\r  \u008a\u0000"+
		"\u0005\u0001\u0000\u0000\u0000\u0000\u0007\u0001\u0000\u0000\u0000\u0000"+
		"\t\u0001\u0000\u0000\u0000\u0000\u000b\u0001\u0000\u0000\u0000\u0000\r"+
		"\u0001\u0000\u0000\u0000\u0000\u000f\u0001\u0000\u0000\u0000\u0000\u0011"+
		"\u0001\u0000\u0000\u0000\u0000\u0013\u0001\u0000\u0000\u0000\u0000\u0015"+
		"\u0001\u0000\u0000\u0000\u0000\u0017\u0001\u0000\u0000\u0000\u0000\u0019"+
		"\u0001\u0000\u0000\u0000\u0000\u001b\u0001\u0000\u0000\u0000\u0000\u001d"+
		"\u0001\u0000\u0000\u0000\u0000\u001f\u0001\u0000\u0000\u0000\u0000!\u0001"+
		"\u0000\u0000\u0000\u0000#\u0001\u0000\u0000\u0000\u0000%\u0001\u0000\u0000"+
		"\u0000\u0000\'\u0001\u0000\u0000\u0000\u0000)\u0001\u0000\u0000\u0000"+
		"\u0001+\u0001\u0000\u0000\u0000\u0003-\u0001\u0000\u0000\u0000\u0005/"+
		"\u0001\u0000\u0000\u0000\u00071\u0001\u0000\u0000\u0000\t3\u0001\u0000"+
		"\u0000\u0000\u000b5\u0001\u0000\u0000\u0000\r7\u0001\u0000\u0000\u0000"+
		"\u000f9\u0001\u0000\u0000\u0000\u0011;\u0001\u0000\u0000\u0000\u0013="+
		"\u0001\u0000\u0000\u0000\u0015?\u0001\u0000\u0000\u0000\u0017A\u0001\u0000"+
		"\u0000\u0000\u0019C\u0001\u0000\u0000\u0000\u001bE\u0001\u0000\u0000\u0000"+
		"\u001dN\u0001\u0000\u0000\u0000\u001fY\u0001\u0000\u0000\u0000!^\u0001"+
		"\u0000\u0000\u0000#l\u0001\u0000\u0000\u0000%n\u0001\u0000\u0000\u0000"+
		"\'w\u0001\u0000\u0000\u0000)}\u0001\u0000\u0000\u0000+,\u0007\u0000\u0000"+
		"\u0000,\u0002\u0001\u0000\u0000\u0000-.\u0007\u0001\u0000\u0000.\u0004"+
		"\u0001\u0000\u0000\u0000/0\u0005+\u0000\u00000\u0006\u0001\u0000\u0000"+
		"\u000012\u0005-\u0000\u00002\b\u0001\u0000\u0000\u000034\u0005*\u0000"+
		"\u00004\n\u0001\u0000\u0000\u000056\u0005/\u0000\u00006\f\u0001\u0000"+
		"\u0000\u000078\u0005^\u0000\u00008\u000e\u0001\u0000\u0000\u00009:\u0005"+
		"=\u0000\u0000:\u0010\u0001\u0000\u0000\u0000;<\u0005(\u0000\u0000<\u0012"+
		"\u0001\u0000\u0000\u0000=>\u0005)\u0000\u0000>\u0014\u0001\u0000\u0000"+
		"\u0000?@\u0005{\u0000\u0000@\u0016\u0001\u0000\u0000\u0000AB\u0005}\u0000"+
		"\u0000B\u0018\u0001\u0000\u0000\u0000CD\u0005;\u0000\u0000D\u001a\u0001"+
		"\u0000\u0000\u0000EF\u0005r\u0000\u0000FG\u0005e\u0000\u0000GH\u0005t"+
		"\u0000\u0000HI\u0005u\u0000\u0000IJ\u0005r\u0000\u0000JK\u0005n\u0000"+
		"\u0000K\u001c\u0001\u0000\u0000\u0000LO\u0003\u0001\u0000\u0000MO\u0005"+
		"_\u0000\u0000NL\u0001\u0000\u0000\u0000NM\u0001\u0000\u0000\u0000OU\u0001"+
		"\u0000\u0000\u0000PT\u0003\u0001\u0000\u0000QT\u0003\u0003\u0001\u0000"+
		"RT\u0005_\u0000\u0000SP\u0001\u0000\u0000\u0000SQ\u0001\u0000\u0000\u0000"+
		"SR\u0001\u0000\u0000\u0000TW\u0001\u0000\u0000\u0000US\u0001\u0000\u0000"+
		"\u0000UV\u0001\u0000\u0000\u0000V\u001e\u0001\u0000\u0000\u0000WU\u0001"+
		"\u0000\u0000\u0000XZ\u0003\u0003\u0001\u0000YX\u0001\u0000\u0000\u0000"+
		"Z[\u0001\u0000\u0000\u0000[Y\u0001\u0000\u0000\u0000[\\\u0001\u0000\u0000"+
		"\u0000\\ \u0001\u0000\u0000\u0000]_\u0003\u0003\u0001\u0000^]\u0001\u0000"+
		"\u0000\u0000_`\u0001\u0000\u0000\u0000`^\u0001\u0000\u0000\u0000`a\u0001"+
		"\u0000\u0000\u0000ah\u0001\u0000\u0000\u0000bd\u0005.\u0000\u0000ce\u0003"+
		"\u0003\u0001\u0000dc\u0001\u0000\u0000\u0000ef\u0001\u0000\u0000\u0000"+
		"fd\u0001\u0000\u0000\u0000fg\u0001\u0000\u0000\u0000gi\u0001\u0000\u0000"+
		"\u0000hb\u0001\u0000\u0000\u0000hi\u0001\u0000\u0000\u0000i\"\u0001\u0000"+
		"\u0000\u0000jm\u0003\u001f\u000f\u0000km\u0003!\u0010\u0000lj\u0001\u0000"+
		"\u0000\u0000lk\u0001\u0000\u0000\u0000m$\u0001\u0000\u0000\u0000no\u0005"+
		"\u0000\u0000\u0001op\u0001\u0000\u0000\u0000pq\u0006\u0012\u0000\u0000"+
		"q&\u0001\u0000\u0000\u0000rt\u0005\r\u0000\u0000sr\u0001\u0000\u0000\u0000"+
		"st\u0001\u0000\u0000\u0000tu\u0001\u0000\u0000\u0000ux\u0005\n\u0000\u0000"+
		"vx\u0005\r\u0000\u0000ws\u0001\u0000\u0000\u0000wv\u0001\u0000\u0000\u0000"+
		"xy\u0001\u0000\u0000\u0000yw\u0001\u0000\u0000\u0000yz\u0001\u0000\u0000"+
		"\u0000z{\u0001\u0000\u0000\u0000{|\u0006\u0013\u0000\u0000|(\u0001\u0000"+
		"\u0000\u0000}~\u0007\u0002\u0000\u0000~\u007f\u0001\u0000\u0000\u0000"+
		"\u007f\u0080\u0006\u0014\u0000\u0000\u0080*\u0001\u0000\u0000\u0000\f"+
		"\u0000NSU[`fhlswy\u0001\u0006\u0000\u0000";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}