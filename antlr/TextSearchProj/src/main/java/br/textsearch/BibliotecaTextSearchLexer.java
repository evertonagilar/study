// Generated from /home/evertonagilar/desenvolvimento/workspace_producao/TextSearchProj/src/main/resources/BibliotecaTextSearch.g4 by ANTLR 4.10.1
package br.textsearch;
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class BibliotecaTextSearchLexer extends Lexer {
	static { RuntimeMetaData.checkVersion("4.10.1", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, T__1=2, SAYS=3, SHOUTS=4, TEXT=5, WHITESPACE=6, NEWLINE=7;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	private static String[] makeRuleNames() {
		return new String[] {
			"T__0", "T__1", "A", "S", "Y", "H", "O", "U", "T", "LOWERCASE", "UPPERCASE", 
			"SAYS", "SHOUTS", "TEXT", "WHITESPACE", "NEWLINE"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "'('", "')'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, null, "SAYS", "SHOUTS", "TEXT", "WHITESPACE", "NEWLINE"
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


	public BibliotecaTextSearchLexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "BibliotecaTextSearch.g4"; }

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
		"\u0004\u0000\u0007W\u0006\uffff\uffff\u0002\u0000\u0007\u0000\u0002\u0001"+
		"\u0007\u0001\u0002\u0002\u0007\u0002\u0002\u0003\u0007\u0003\u0002\u0004"+
		"\u0007\u0004\u0002\u0005\u0007\u0005\u0002\u0006\u0007\u0006\u0002\u0007"+
		"\u0007\u0007\u0002\b\u0007\b\u0002\t\u0007\t\u0002\n\u0007\n\u0002\u000b"+
		"\u0007\u000b\u0002\f\u0007\f\u0002\r\u0007\r\u0002\u000e\u0007\u000e\u0002"+
		"\u000f\u0007\u000f\u0001\u0000\u0001\u0000\u0001\u0001\u0001\u0001\u0001"+
		"\u0002\u0001\u0002\u0001\u0003\u0001\u0003\u0001\u0004\u0001\u0004\u0001"+
		"\u0005\u0001\u0005\u0001\u0006\u0001\u0006\u0001\u0007\u0001\u0007\u0001"+
		"\b\u0001\b\u0001\t\u0001\t\u0001\n\u0001\n\u0001\u000b\u0001\u000b\u0001"+
		"\u000b\u0001\u000b\u0001\u000b\u0001\f\u0001\f\u0001\f\u0001\f\u0001\f"+
		"\u0001\f\u0001\f\u0001\r\u0001\r\u0001\r\u0004\rG\b\r\u000b\r\f\rH\u0001"+
		"\u000e\u0001\u000e\u0001\u000e\u0001\u000e\u0001\u000f\u0003\u000fP\b"+
		"\u000f\u0001\u000f\u0001\u000f\u0004\u000fT\b\u000f\u000b\u000f\f\u000f"+
		"U\u0000\u0000\u0010\u0001\u0001\u0003\u0002\u0005\u0000\u0007\u0000\t"+
		"\u0000\u000b\u0000\r\u0000\u000f\u0000\u0011\u0000\u0013\u0000\u0015\u0000"+
		"\u0017\u0003\u0019\u0004\u001b\u0005\u001d\u0006\u001f\u0007\u0001\u0000"+
		"\n\u0002\u0000AAaa\u0002\u0000SSss\u0002\u0000YYyy\u0002\u0000HHhh\u0002"+
		"\u0000OOoo\u0002\u0000UUuu\u0002\u0000TTtt\u0001\u0000az\u0001\u0000A"+
		"Z\u0002\u0000\t\t  S\u0000\u0001\u0001\u0000\u0000\u0000\u0000\u0003\u0001"+
		"\u0000\u0000\u0000\u0000\u0017\u0001\u0000\u0000\u0000\u0000\u0019\u0001"+
		"\u0000\u0000\u0000\u0000\u001b\u0001\u0000\u0000\u0000\u0000\u001d\u0001"+
		"\u0000\u0000\u0000\u0000\u001f\u0001\u0000\u0000\u0000\u0001!\u0001\u0000"+
		"\u0000\u0000\u0003#\u0001\u0000\u0000\u0000\u0005%\u0001\u0000\u0000\u0000"+
		"\u0007\'\u0001\u0000\u0000\u0000\t)\u0001\u0000\u0000\u0000\u000b+\u0001"+
		"\u0000\u0000\u0000\r-\u0001\u0000\u0000\u0000\u000f/\u0001\u0000\u0000"+
		"\u0000\u00111\u0001\u0000\u0000\u0000\u00133\u0001\u0000\u0000\u0000\u0015"+
		"5\u0001\u0000\u0000\u0000\u00177\u0001\u0000\u0000\u0000\u0019<\u0001"+
		"\u0000\u0000\u0000\u001bF\u0001\u0000\u0000\u0000\u001dJ\u0001\u0000\u0000"+
		"\u0000\u001fS\u0001\u0000\u0000\u0000!\"\u0005(\u0000\u0000\"\u0002\u0001"+
		"\u0000\u0000\u0000#$\u0005)\u0000\u0000$\u0004\u0001\u0000\u0000\u0000"+
		"%&\u0007\u0000\u0000\u0000&\u0006\u0001\u0000\u0000\u0000\'(\u0007\u0001"+
		"\u0000\u0000(\b\u0001\u0000\u0000\u0000)*\u0007\u0002\u0000\u0000*\n\u0001"+
		"\u0000\u0000\u0000+,\u0007\u0003\u0000\u0000,\f\u0001\u0000\u0000\u0000"+
		"-.\u0007\u0004\u0000\u0000.\u000e\u0001\u0000\u0000\u0000/0\u0007\u0005"+
		"\u0000\u00000\u0010\u0001\u0000\u0000\u000012\u0007\u0006\u0000\u0000"+
		"2\u0012\u0001\u0000\u0000\u000034\u0007\u0007\u0000\u00004\u0014\u0001"+
		"\u0000\u0000\u000056\u0007\b\u0000\u00006\u0016\u0001\u0000\u0000\u0000"+
		"78\u0003\u0007\u0003\u000089\u0003\u0005\u0002\u00009:\u0003\t\u0004\u0000"+
		":;\u0003\u0007\u0003\u0000;\u0018\u0001\u0000\u0000\u0000<=\u0003\u0007"+
		"\u0003\u0000=>\u0003\u000b\u0005\u0000>?\u0003\r\u0006\u0000?@\u0003\u000f"+
		"\u0007\u0000@A\u0003\u0011\b\u0000AB\u0003\u0007\u0003\u0000B\u001a\u0001"+
		"\u0000\u0000\u0000CG\u0003\u0013\t\u0000DG\u0003\u0015\n\u0000EG\u0005"+
		"_\u0000\u0000FC\u0001\u0000\u0000\u0000FD\u0001\u0000\u0000\u0000FE\u0001"+
		"\u0000\u0000\u0000GH\u0001\u0000\u0000\u0000HF\u0001\u0000\u0000\u0000"+
		"HI\u0001\u0000\u0000\u0000I\u001c\u0001\u0000\u0000\u0000JK\u0007\t\u0000"+
		"\u0000KL\u0001\u0000\u0000\u0000LM\u0006\u000e\u0000\u0000M\u001e\u0001"+
		"\u0000\u0000\u0000NP\u0005\r\u0000\u0000ON\u0001\u0000\u0000\u0000OP\u0001"+
		"\u0000\u0000\u0000PQ\u0001\u0000\u0000\u0000QT\u0005\n\u0000\u0000RT\u0005"+
		"\r\u0000\u0000SO\u0001\u0000\u0000\u0000SR\u0001\u0000\u0000\u0000TU\u0001"+
		"\u0000\u0000\u0000US\u0001\u0000\u0000\u0000UV\u0001\u0000\u0000\u0000"+
		"V \u0001\u0000\u0000\u0000\u0006\u0000FHOSU\u0001\u0006\u0000\u0000";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}