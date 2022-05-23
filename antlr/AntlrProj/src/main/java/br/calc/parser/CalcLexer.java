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
		T__0=1, ADD_OP=2, SUB_OP=3, MUL_OP=4, DIV_OP=5, POW_OP=6, ASSIGN_OP=7, 
		LPARENT=8, RPARENT=9, BEGIN_BLOCK=10, END_BLOCK=11, STATEMENT_RET=12, 
		RETURN=13, ID=14, INT=15, DOUBLE=16, NUMBER=17, END=18, NEWLINE=19, WS=20;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	private static String[] makeRuleNames() {
		return new String[] {
			"T__0", "LETTER", "DIGIT", "ADD_OP", "SUB_OP", "MUL_OP", "DIV_OP", "POW_OP", 
			"ASSIGN_OP", "LPARENT", "RPARENT", "BEGIN_BLOCK", "END_BLOCK", "STATEMENT_RET", 
			"RETURN", "ID", "INT", "DOUBLE", "NUMBER", "END", "NEWLINE", "WS"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "','", "'+'", "'-'", "'*'", "'/'", "'^'", "'='", "'('", "')'", 
			"'{'", "'}'", "';'", "'return'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, "ADD_OP", "SUB_OP", "MUL_OP", "DIV_OP", "POW_OP", "ASSIGN_OP", 
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
		"\u0004\u0000\u0014\u0085\u0006\uffff\uffff\u0002\u0000\u0007\u0000\u0002"+
		"\u0001\u0007\u0001\u0002\u0002\u0007\u0002\u0002\u0003\u0007\u0003\u0002"+
		"\u0004\u0007\u0004\u0002\u0005\u0007\u0005\u0002\u0006\u0007\u0006\u0002"+
		"\u0007\u0007\u0007\u0002\b\u0007\b\u0002\t\u0007\t\u0002\n\u0007\n\u0002"+
		"\u000b\u0007\u000b\u0002\f\u0007\f\u0002\r\u0007\r\u0002\u000e\u0007\u000e"+
		"\u0002\u000f\u0007\u000f\u0002\u0010\u0007\u0010\u0002\u0011\u0007\u0011"+
		"\u0002\u0012\u0007\u0012\u0002\u0013\u0007\u0013\u0002\u0014\u0007\u0014"+
		"\u0002\u0015\u0007\u0015\u0001\u0000\u0001\u0000\u0001\u0001\u0001\u0001"+
		"\u0001\u0002\u0001\u0002\u0001\u0003\u0001\u0003\u0001\u0004\u0001\u0004"+
		"\u0001\u0005\u0001\u0005\u0001\u0006\u0001\u0006\u0001\u0007\u0001\u0007"+
		"\u0001\b\u0001\b\u0001\t\u0001\t\u0001\n\u0001\n\u0001\u000b\u0001\u000b"+
		"\u0001\f\u0001\f\u0001\r\u0001\r\u0001\u000e\u0001\u000e\u0001\u000e\u0001"+
		"\u000e\u0001\u000e\u0001\u000e\u0001\u000e\u0001\u000f\u0001\u000f\u0003"+
		"\u000fS\b\u000f\u0001\u000f\u0001\u000f\u0001\u000f\u0005\u000fX\b\u000f"+
		"\n\u000f\f\u000f[\t\u000f\u0001\u0010\u0004\u0010^\b\u0010\u000b\u0010"+
		"\f\u0010_\u0001\u0011\u0004\u0011c\b\u0011\u000b\u0011\f\u0011d\u0001"+
		"\u0011\u0001\u0011\u0004\u0011i\b\u0011\u000b\u0011\f\u0011j\u0003\u0011"+
		"m\b\u0011\u0001\u0012\u0001\u0012\u0003\u0012q\b\u0012\u0001\u0013\u0001"+
		"\u0013\u0001\u0013\u0001\u0013\u0001\u0014\u0003\u0014x\b\u0014\u0001"+
		"\u0014\u0001\u0014\u0004\u0014|\b\u0014\u000b\u0014\f\u0014}\u0001\u0014"+
		"\u0001\u0014\u0001\u0015\u0001\u0015\u0001\u0015\u0001\u0015\u0000\u0000"+
		"\u0016\u0001\u0001\u0003\u0000\u0005\u0000\u0007\u0002\t\u0003\u000b\u0004"+
		"\r\u0005\u000f\u0006\u0011\u0007\u0013\b\u0015\t\u0017\n\u0019\u000b\u001b"+
		"\f\u001d\r\u001f\u000e!\u000f#\u0010%\u0011\'\u0012)\u0013+\u0014\u0001"+
		"\u0000\u0003\u0002\u0000AZaz\u0001\u000009\u0002\u0000\r\r  \u008e\u0000"+
		"\u0001\u0001\u0000\u0000\u0000\u0000\u0007\u0001\u0000\u0000\u0000\u0000"+
		"\t\u0001\u0000\u0000\u0000\u0000\u000b\u0001\u0000\u0000\u0000\u0000\r"+
		"\u0001\u0000\u0000\u0000\u0000\u000f\u0001\u0000\u0000\u0000\u0000\u0011"+
		"\u0001\u0000\u0000\u0000\u0000\u0013\u0001\u0000\u0000\u0000\u0000\u0015"+
		"\u0001\u0000\u0000\u0000\u0000\u0017\u0001\u0000\u0000\u0000\u0000\u0019"+
		"\u0001\u0000\u0000\u0000\u0000\u001b\u0001\u0000\u0000\u0000\u0000\u001d"+
		"\u0001\u0000\u0000\u0000\u0000\u001f\u0001\u0000\u0000\u0000\u0000!\u0001"+
		"\u0000\u0000\u0000\u0000#\u0001\u0000\u0000\u0000\u0000%\u0001\u0000\u0000"+
		"\u0000\u0000\'\u0001\u0000\u0000\u0000\u0000)\u0001\u0000\u0000\u0000"+
		"\u0000+\u0001\u0000\u0000\u0000\u0001-\u0001\u0000\u0000\u0000\u0003/"+
		"\u0001\u0000\u0000\u0000\u00051\u0001\u0000\u0000\u0000\u00073\u0001\u0000"+
		"\u0000\u0000\t5\u0001\u0000\u0000\u0000\u000b7\u0001\u0000\u0000\u0000"+
		"\r9\u0001\u0000\u0000\u0000\u000f;\u0001\u0000\u0000\u0000\u0011=\u0001"+
		"\u0000\u0000\u0000\u0013?\u0001\u0000\u0000\u0000\u0015A\u0001\u0000\u0000"+
		"\u0000\u0017C\u0001\u0000\u0000\u0000\u0019E\u0001\u0000\u0000\u0000\u001b"+
		"G\u0001\u0000\u0000\u0000\u001dI\u0001\u0000\u0000\u0000\u001fR\u0001"+
		"\u0000\u0000\u0000!]\u0001\u0000\u0000\u0000#b\u0001\u0000\u0000\u0000"+
		"%p\u0001\u0000\u0000\u0000\'r\u0001\u0000\u0000\u0000){\u0001\u0000\u0000"+
		"\u0000+\u0081\u0001\u0000\u0000\u0000-.\u0005,\u0000\u0000.\u0002\u0001"+
		"\u0000\u0000\u0000/0\u0007\u0000\u0000\u00000\u0004\u0001\u0000\u0000"+
		"\u000012\u0007\u0001\u0000\u00002\u0006\u0001\u0000\u0000\u000034\u0005"+
		"+\u0000\u00004\b\u0001\u0000\u0000\u000056\u0005-\u0000\u00006\n\u0001"+
		"\u0000\u0000\u000078\u0005*\u0000\u00008\f\u0001\u0000\u0000\u00009:\u0005"+
		"/\u0000\u0000:\u000e\u0001\u0000\u0000\u0000;<\u0005^\u0000\u0000<\u0010"+
		"\u0001\u0000\u0000\u0000=>\u0005=\u0000\u0000>\u0012\u0001\u0000\u0000"+
		"\u0000?@\u0005(\u0000\u0000@\u0014\u0001\u0000\u0000\u0000AB\u0005)\u0000"+
		"\u0000B\u0016\u0001\u0000\u0000\u0000CD\u0005{\u0000\u0000D\u0018\u0001"+
		"\u0000\u0000\u0000EF\u0005}\u0000\u0000F\u001a\u0001\u0000\u0000\u0000"+
		"GH\u0005;\u0000\u0000H\u001c\u0001\u0000\u0000\u0000IJ\u0005r\u0000\u0000"+
		"JK\u0005e\u0000\u0000KL\u0005t\u0000\u0000LM\u0005u\u0000\u0000MN\u0005"+
		"r\u0000\u0000NO\u0005n\u0000\u0000O\u001e\u0001\u0000\u0000\u0000PS\u0003"+
		"\u0003\u0001\u0000QS\u0005_\u0000\u0000RP\u0001\u0000\u0000\u0000RQ\u0001"+
		"\u0000\u0000\u0000SY\u0001\u0000\u0000\u0000TX\u0003\u0003\u0001\u0000"+
		"UX\u0003\u0005\u0002\u0000VX\u0005_\u0000\u0000WT\u0001\u0000\u0000\u0000"+
		"WU\u0001\u0000\u0000\u0000WV\u0001\u0000\u0000\u0000X[\u0001\u0000\u0000"+
		"\u0000YW\u0001\u0000\u0000\u0000YZ\u0001\u0000\u0000\u0000Z \u0001\u0000"+
		"\u0000\u0000[Y\u0001\u0000\u0000\u0000\\^\u0003\u0005\u0002\u0000]\\\u0001"+
		"\u0000\u0000\u0000^_\u0001\u0000\u0000\u0000_]\u0001\u0000\u0000\u0000"+
		"_`\u0001\u0000\u0000\u0000`\"\u0001\u0000\u0000\u0000ac\u0003\u0005\u0002"+
		"\u0000ba\u0001\u0000\u0000\u0000cd\u0001\u0000\u0000\u0000db\u0001\u0000"+
		"\u0000\u0000de\u0001\u0000\u0000\u0000el\u0001\u0000\u0000\u0000fh\u0005"+
		".\u0000\u0000gi\u0003\u0005\u0002\u0000hg\u0001\u0000\u0000\u0000ij\u0001"+
		"\u0000\u0000\u0000jh\u0001\u0000\u0000\u0000jk\u0001\u0000\u0000\u0000"+
		"km\u0001\u0000\u0000\u0000lf\u0001\u0000\u0000\u0000lm\u0001\u0000\u0000"+
		"\u0000m$\u0001\u0000\u0000\u0000nq\u0003!\u0010\u0000oq\u0003#\u0011\u0000"+
		"pn\u0001\u0000\u0000\u0000po\u0001\u0000\u0000\u0000q&\u0001\u0000\u0000"+
		"\u0000rs\u0005\u0000\u0000\u0001st\u0001\u0000\u0000\u0000tu\u0006\u0013"+
		"\u0000\u0000u(\u0001\u0000\u0000\u0000vx\u0005\r\u0000\u0000wv\u0001\u0000"+
		"\u0000\u0000wx\u0001\u0000\u0000\u0000xy\u0001\u0000\u0000\u0000y|\u0005"+
		"\n\u0000\u0000z|\u0005\r\u0000\u0000{w\u0001\u0000\u0000\u0000{z\u0001"+
		"\u0000\u0000\u0000|}\u0001\u0000\u0000\u0000}{\u0001\u0000\u0000\u0000"+
		"}~\u0001\u0000\u0000\u0000~\u007f\u0001\u0000\u0000\u0000\u007f\u0080"+
		"\u0006\u0014\u0000\u0000\u0080*\u0001\u0000\u0000\u0000\u0081\u0082\u0007"+
		"\u0002\u0000\u0000\u0082\u0083\u0001\u0000\u0000\u0000\u0083\u0084\u0006"+
		"\u0015\u0000\u0000\u0084,\u0001\u0000\u0000\u0000\f\u0000RWY_djlpw{}\u0001"+
		"\u0006\u0000\u0000";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}