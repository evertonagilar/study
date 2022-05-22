// Generated from /home/evertonagilar/desenvolvimento/workspace_producao/TextSearchProj/src/main/resources/BibliotecaTextSearch.g4 by ANTLR 4.10.1
package br.textsearch.parser;
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
		ASPA_SIMPLES=1, WHITESPACE=2, LPAREN=3, RPAREN=4, OR=5, AND=6, NOT=7, 
		STRING=8, TEXT=9, SPECIAL_CHAR=10, NEWLINE=11, END=12;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	private static String[] makeRuleNames() {
		return new String[] {
			"LOWERCASE", "UPPERCASE", "DIGIT", "ASPA_SIMPLES", "WHITESPACE", "LPAREN", 
			"RPAREN", "OR", "AND", "NOT", "STRING", "TEXT", "SPECIAL_CHAR", "NEWLINE", 
			"END"
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
		"\u0004\u0000\fg\u0006\uffff\uffff\u0002\u0000\u0007\u0000\u0002\u0001"+
		"\u0007\u0001\u0002\u0002\u0007\u0002\u0002\u0003\u0007\u0003\u0002\u0004"+
		"\u0007\u0004\u0002\u0005\u0007\u0005\u0002\u0006\u0007\u0006\u0002\u0007"+
		"\u0007\u0007\u0002\b\u0007\b\u0002\t\u0007\t\u0002\n\u0007\n\u0002\u000b"+
		"\u0007\u000b\u0002\f\u0007\f\u0002\r\u0007\r\u0002\u000e\u0007\u000e\u0001"+
		"\u0000\u0001\u0000\u0001\u0001\u0001\u0001\u0001\u0002\u0001\u0002\u0001"+
		"\u0003\u0001\u0003\u0001\u0003\u0001\u0003\u0001\u0004\u0001\u0004\u0001"+
		"\u0004\u0001\u0004\u0001\u0005\u0001\u0005\u0001\u0006\u0001\u0006\u0001"+
		"\u0007\u0001\u0007\u0001\u0007\u0001\u0007\u0003\u00076\b\u0007\u0001"+
		"\b\u0001\b\u0001\b\u0001\b\u0001\b\u0003\b=\b\b\u0001\t\u0001\t\u0001"+
		"\t\u0001\t\u0003\tC\b\t\u0001\n\u0001\n\u0001\n\u0001\n\u0005\nI\b\n\n"+
		"\n\f\nL\t\n\u0001\n\u0001\n\u0001\u000b\u0001\u000b\u0001\u000b\u0001"+
		"\u000b\u0001\u000b\u0004\u000bU\b\u000b\u000b\u000b\f\u000bV\u0001\f\u0001"+
		"\f\u0001\r\u0003\r\\\b\r\u0001\r\u0001\r\u0004\r`\b\r\u000b\r\f\ra\u0001"+
		"\u000e\u0001\u000e\u0001\u000e\u0001\u000e\u0000\u0000\u000f\u0001\u0000"+
		"\u0003\u0000\u0005\u0000\u0007\u0001\t\u0002\u000b\u0003\r\u0004\u000f"+
		"\u0005\u0011\u0006\u0013\u0007\u0015\b\u0017\t\u0019\n\u001b\u000b\u001d"+
		"\f\u0001\u0000\b\u0002\u0000az\u00e1\u00fa\u0002\u0000AZ\u00c1\u00da\u0001"+
		"\u000009\u0002\u0000\t\t  \u0004\u0000\n\n\r\r\"\"\\\\\u0002\u0000\"\""+
		"\\\\\u0004\u0000#$**,.??\t\u0000!!%%::==@@[[]^{{}~p\u0000\u0007\u0001"+
		"\u0000\u0000\u0000\u0000\t\u0001\u0000\u0000\u0000\u0000\u000b\u0001\u0000"+
		"\u0000\u0000\u0000\r\u0001\u0000\u0000\u0000\u0000\u000f\u0001\u0000\u0000"+
		"\u0000\u0000\u0011\u0001\u0000\u0000\u0000\u0000\u0013\u0001\u0000\u0000"+
		"\u0000\u0000\u0015\u0001\u0000\u0000\u0000\u0000\u0017\u0001\u0000\u0000"+
		"\u0000\u0000\u0019\u0001\u0000\u0000\u0000\u0000\u001b\u0001\u0000\u0000"+
		"\u0000\u0000\u001d\u0001\u0000\u0000\u0000\u0001\u001f\u0001\u0000\u0000"+
		"\u0000\u0003!\u0001\u0000\u0000\u0000\u0005#\u0001\u0000\u0000\u0000\u0007"+
		"%\u0001\u0000\u0000\u0000\t)\u0001\u0000\u0000\u0000\u000b-\u0001\u0000"+
		"\u0000\u0000\r/\u0001\u0000\u0000\u0000\u000f5\u0001\u0000\u0000\u0000"+
		"\u0011<\u0001\u0000\u0000\u0000\u0013B\u0001\u0000\u0000\u0000\u0015D"+
		"\u0001\u0000\u0000\u0000\u0017T\u0001\u0000\u0000\u0000\u0019X\u0001\u0000"+
		"\u0000\u0000\u001b_\u0001\u0000\u0000\u0000\u001dc\u0001\u0000\u0000\u0000"+
		"\u001f \u0007\u0000\u0000\u0000 \u0002\u0001\u0000\u0000\u0000!\"\u0007"+
		"\u0001\u0000\u0000\"\u0004\u0001\u0000\u0000\u0000#$\u0007\u0002\u0000"+
		"\u0000$\u0006\u0001\u0000\u0000\u0000%&\u0005\'\u0000\u0000&\'\u0001\u0000"+
		"\u0000\u0000\'(\u0006\u0003\u0000\u0000(\b\u0001\u0000\u0000\u0000)*\u0007"+
		"\u0003\u0000\u0000*+\u0001\u0000\u0000\u0000+,\u0006\u0004\u0000\u0000"+
		",\n\u0001\u0000\u0000\u0000-.\u0005(\u0000\u0000.\f\u0001\u0000\u0000"+
		"\u0000/0\u0005)\u0000\u00000\u000e\u0001\u0000\u0000\u000012\u0005O\u0000"+
		"\u000026\u0005R\u0000\u000034\u0005|\u0000\u000046\u0005|\u0000\u0000"+
		"51\u0001\u0000\u0000\u000053\u0001\u0000\u0000\u00006\u0010\u0001\u0000"+
		"\u0000\u000078\u0005A\u0000\u000089\u0005N\u0000\u00009=\u0005D\u0000"+
		"\u0000:;\u0005&\u0000\u0000;=\u0005&\u0000\u0000<7\u0001\u0000\u0000\u0000"+
		"<:\u0001\u0000\u0000\u0000=\u0012\u0001\u0000\u0000\u0000>?\u0005N\u0000"+
		"\u0000?@\u0005O\u0000\u0000@C\u0005T\u0000\u0000AC\u0005-\u0000\u0000"+
		"B>\u0001\u0000\u0000\u0000BA\u0001\u0000\u0000\u0000C\u0014\u0001\u0000"+
		"\u0000\u0000DJ\u0005\"\u0000\u0000EI\b\u0004\u0000\u0000FG\u0005\\\u0000"+
		"\u0000GI\u0007\u0005\u0000\u0000HE\u0001\u0000\u0000\u0000HF\u0001\u0000"+
		"\u0000\u0000IL\u0001\u0000\u0000\u0000JH\u0001\u0000\u0000\u0000JK\u0001"+
		"\u0000\u0000\u0000KM\u0001\u0000\u0000\u0000LJ\u0001\u0000\u0000\u0000"+
		"MN\u0005\"\u0000\u0000N\u0016\u0001\u0000\u0000\u0000OU\u0003\u0003\u0001"+
		"\u0000PU\u0003\u0001\u0000\u0000QU\u0003\u0005\u0002\u0000RU\u0007\u0006"+
		"\u0000\u0000SU\u0003\u0019\f\u0000TO\u0001\u0000\u0000\u0000TP\u0001\u0000"+
		"\u0000\u0000TQ\u0001\u0000\u0000\u0000TR\u0001\u0000\u0000\u0000TS\u0001"+
		"\u0000\u0000\u0000UV\u0001\u0000\u0000\u0000VT\u0001\u0000\u0000\u0000"+
		"VW\u0001\u0000\u0000\u0000W\u0018\u0001\u0000\u0000\u0000XY\u0007\u0007"+
		"\u0000\u0000Y\u001a\u0001\u0000\u0000\u0000Z\\\u0005\r\u0000\u0000[Z\u0001"+
		"\u0000\u0000\u0000[\\\u0001\u0000\u0000\u0000\\]\u0001\u0000\u0000\u0000"+
		"]`\u0005\n\u0000\u0000^`\u0005\r\u0000\u0000_[\u0001\u0000\u0000\u0000"+
		"_^\u0001\u0000\u0000\u0000`a\u0001\u0000\u0000\u0000a_\u0001\u0000\u0000"+
		"\u0000ab\u0001\u0000\u0000\u0000b\u001c\u0001\u0000\u0000\u0000cd\u0005"+
		"\u0000\u0000\u0001de\u0001\u0000\u0000\u0000ef\u0006\u000e\u0000\u0000"+
		"f\u001e\u0001\u0000\u0000\u0000\u000b\u00005<BHJTV[_a\u0001\u0006\u0000"+
		"\u0000";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}